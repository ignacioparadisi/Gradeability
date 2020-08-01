//
//  AssignmentDetailViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine
import EventKit

protocol AssignmentDetailViewModelDelegate: class {
    func didSave(_ assignment: Assignment?)
}

class AssignmentDetailViewModel {
    
    // MARK: Properties
    
    struct Sections {
        static var name = 0
        static var grades = 1
        static var deadline = 2
        static var delete = 3
    }

    private var fields: [[FieldRepresentable]] = []
    /// Assignment to show the details.
    private var assignment: Assignment?
    /// Subject where the assignment belongs.
    private var subject: Subject?
    /// Delegate to handler deletion and saving.
    weak var delegate: AssignmentDetailViewModelDelegate?
    /// Name for the assignment.
    @Published var name: String?
    /// Grade for the assignment.
    @Published var grade: Float?
    /// Percentage for the assignment.
    @Published var percentage: Float?
    /// Maximum grade for the assignment.
    @Published var maxGrade: Float?
    /// Minimum grade for the assignment.
    @Published var minGrade: Float?
    /// Deadline for the assignment.
    @Published var deadline: Date?
    /// Whether the event for the assignment should be created in Calendar or no.
    var createEvent: Bool = true
    /// Whether the user is editing an existing assignment or creating a new one.
    private(set) var isEditing: Bool = false
    /// Whether data has been changed or not.
    var isDataChanged: Bool {
        if let assignment = assignment {
            return assignment.name != name ||
                assignment.grade as Float? != grade ||
                assignment.minGrade as Float? != minGrade ||
                assignment.maxGrade as Float? != maxGrade ||
                assignment.deadline != deadline ||
                assignment.percentage as Float? != (percentage ?? 0) / 100
        } else {
            return (name != nil && name != "") ||
                (grade != nil && grade != 0) ||
                minGrade != nil ||
                maxGrade != nil ||
                percentage != nil ||
                deadline != nil
        }
    }
    /// Title for delete alert.
    var deleteTitle: String {
        return String(format: AssignmentString.deleteTitle.localized, assignment?.name ?? "")
    }
    var canOpenEvent: Bool {
        if !isEditing {
            return true
        }
        return isEditing && assignment?.eventIdentifier != nil
    }
    var numberOfSections: Int {
        return fields.count
    }
    
    // MARK: Initializers
    
    init(assignment: Assignment) {
        self.assignment = assignment
        self.name = assignment.name
        self.percentage = assignment.percentage * 100
        self.minGrade = assignment.minGrade
        self.maxGrade = assignment.maxGrade
        self.grade = assignment.grade
        self.deadline = assignment.deadline
        self.subject = assignment.subject
        self.isEditing = true
        setupFields()
    }
    
    init(subject: Subject) {
        self.subject = subject
        self.isEditing = false
        self.createEvent = !accessToCalendarIsDenied
        setupFields()
    }
    
    // MARK: Functions
    private func setupFields() {
        fields = [
            [
                Field<String>(title: GlobalStrings.name.localized, value: assignment?.name, type: .largeTextField)
            ],
            [
                Field<Float>(title: GlobalStrings.grade.localized, value: assignment?.grade, type: .circularPicker),
                Field<Float>(title: GlobalStrings.minGrade.localized, value: assignment?.minGrade, type: .decimalTextField),
                Field<Float>(title: GlobalStrings.maxGrade.localized, value: assignment?.maxGrade, type: .decimalTextField)
            ],
            [
                Field<Date>(title: AssignmentString.deadline.localized, value: assignment?.deadline, type: .datePicker)
            ]
        ]
        
        if isEditing {
            fields[Sections.deadline].append(ButtonField(title: AssignmentString.openEventInCalendar.localized))
            fields.append([
                ButtonField(title: ButtonStrings.delete.localized, type: .destructiveButton)
            ])
        } else {
            fields[Sections.deadline].append(Field<Bool>(title: AssignmentString.createEventInCalendar.localized, value: !accessToCalendarIsDenied, type: .switch))
        }
    }
    
    func numberOfRows(in section: Int) -> Int {
        return fields[section].count
    }
    
    func field(for indexPath: IndexPath) -> FieldRepresentable {
        let section = indexPath.section
        let row = indexPath.row
        return fields[section][row]
    }
    
    /// Updates or creates an assignments in `CoreData`.
    func save() {
        guard let name = name,
            let percentage = percentage,
            let minGrade = minGrade,
            let maxGrade = maxGrade else { return }
        var assignment: Assignment?
        if self.assignment != nil {
            assignment = self.assignment
        }
        self.assignment = AssignmentCoreDataManager.shared.save(existingAssignment: assignment, name: name, maxGrade: maxGrade, minGrade: minGrade, grade: grade, deadline: deadline, percentage: percentage / 100, subject: subject)
        if createEvent && !isEditing {
            createCalendarEventIfAuthorized()
        }
        delegate?.didSave(assignment)
    }
    
    /// Delete assignment from CoreData.
    func delete() {
        guard let assignment = assignment else { return }
        AssignmentCoreDataManager.shared.delete(assignment)
    }
}

// MARK: - Validations
extension AssignmentDetailViewModel {
    /// Defines if the name textfield is valid.
    var isValidName: AnyPublisher<Bool, Never> {
        return $name
            .map { $0 != nil && $0 != "" }
            .eraseToAnyPublisher()
    }
    /// Defines if grade textfield is valid.
    var isValidGrade: AnyPublisher<Bool?, Never> {
        return $grade
            .map { [weak self] grade in
                guard let grade = grade else { return nil }
                guard let maxGrade = self?.maxGrade else { return nil }
                return grade >= 0 && grade <= maxGrade
            }
            .eraseToAnyPublisher()
    }
    /// Defines if minGrade textfield is valid.
    var isValidMinGrade: AnyPublisher<Bool?, Never> {
        return $minGrade
            .map { [weak self] minGrade in
                guard let minGrade = minGrade else { return nil }
                guard let maxGrade = self?.maxGrade else { return nil }
                return minGrade >= 0 && minGrade < maxGrade
            }
            .eraseToAnyPublisher()
    }
    /// Defines if maxGrade textfield is valid.
    var isValidMaxGrade: AnyPublisher<Bool?, Never> {
        return $maxGrade
            .map { [weak self] maxGrade in
                guard let maxGrade = maxGrade else { return nil }
                guard let minGrade = self?.minGrade else { return nil }
                return maxGrade > minGrade
            }
            .eraseToAnyPublisher()
    }
    /// Defines if all grade textfields are valid.
    var areValidGrades: AnyPublisher<(Bool?, Bool?, Bool?), Never> {
        return Publishers.CombineLatest3(isValidGrade, isValidMinGrade, isValidMaxGrade)
            .eraseToAnyPublisher()
    }
    /// Defines if percentage textfield is valid.
    var isValidPercentage: AnyPublisher<Bool?, Never> {
        return $percentage
            .map { [weak self] percentage in
                guard var percentage = percentage else { return nil }
                if let assignment = self?.assignment {
                    let accumulatedPercentage = SubjectCoreDataManager.shared.getAccumulatedPercentage(assignment: assignment)
                    percentage = percentage / 100 + accumulatedPercentage
                } else if let subject = self?.subject {
                    let accumulatedPercentage = SubjectCoreDataManager.shared.getAccumulatedPercentage(subject: subject)
                    percentage = percentage / 100 + accumulatedPercentage
                }
                print(percentage)
                return percentage <= 1
            }
            .eraseToAnyPublisher()
    }
    /// Defines if deadline textfield is valid.
    var isValidDeadline: AnyPublisher<Bool?, Never> {
        return $deadline
            .map {
                if $0 == nil {
                    return nil
                } else {
                    return true
                }
            }
            .eraseToAnyPublisher()
    }
    /// Defines if all fields are valid.
    var readyToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest4(isValidName, areValidGrades, isValidPercentage, isValidDeadline)
            .map { [weak self] isValidName, areValidGrades, isValidPercentage, isValidDeadline in
                guard let self = self else { return false }
                guard let isValidGrade = areValidGrades.0,
                    let isValidMinGrade = areValidGrades.1,
                    let isValidMaxGrade = areValidGrades.2,
                    let isValidPercentage = isValidPercentage,
                    let isValidDeadline = isValidDeadline else { return false }
                return isValidName && isValidGrade && isValidMinGrade && isValidMaxGrade && isValidPercentage && isValidDeadline && self.isDataChanged
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Calendar
extension AssignmentDetailViewModel {
    /// Whether the user has authorized the app to access de calendar or not.
    private var accessToCalendarIsDenied: Bool {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .denied:
            return true
        default:
            return false
        }
    }
    /// Handles the calendar authorization
    private func createCalendarEventIfAuthorized() {
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event) {
        case .notDetermined:
            requestEventAccess(eventStore)
        case .denied:
            // TODO: Show alert saying that the access to the calendar is denied
            break
        case .authorized:
            createEvent(eventStore)
        default:
            break
        }
    }
    
    /// Request the permission to access the calendar.
    /// - Parameter eventStore: Event Store for the calendar.
    private func requestEventAccess(_ eventStore: EKEventStore) {
        eventStore.requestAccess(to: .event) { [weak self] granted, error in
            if granted {
                self?.createEvent(eventStore)
            }
        }
    }
    
    /// Creates an event into the calendar.
    /// - Parameter eventStore: Event Store for the calendar.
    private func createEvent(_ eventStore: EKEventStore) {
        guard let deadline = deadline else { return }
        let event = EKEvent(eventStore: eventStore)
        event.startDate = deadline
        event.endDate = Calendar.current.date(byAdding: .hour, value: 1, to: deadline)
        guard let assignmentName = name, let subjectName = subject?.name else { return }
        event.title = "\(assignmentName) - \(subjectName)"
        do {
            let calendar = try getCalendar(eventStore)
            event.calendar = calendar
            try eventStore.save(event, span: .thisEvent)
            assignment?.eventIdentifier = event.eventIdentifier
            CoreDataManagerFactory.createManager.saveContext()
        } catch {
            print(error.localizedDescription)
            // TODO: Handle error
        }
    }
    
    /// Searches for the Gradeability calendar or creates it if does not exist.
    /// - Parameter eventStore: Event Store for the calendar.
    /// - Throws: Error when creating the calendar.
    /// - Returns: The Gradeability calendar.
    private func getCalendar(_ eventStore: EKEventStore) throws -> EKCalendar {
        let calendars = eventStore.calendars(for: .event)
        if let calendar = calendars.filter({ $0.title == "Gradeability" }).first {
            return calendar
        }
        // Create new calendar if does not exist
        let calendar = EKCalendar(for: .event, eventStore: eventStore)
        calendar.title = "Gradeability"
        calendar.source = eventStore.defaultCalendarForNewEvents?.source
        calendar.cgColor = UIColor.systemBlue.cgColor
        try eventStore.saveCalendar(calendar, commit: true)
        return calendar
    }
    
    /// Opens the Calendar app with the current event.
    func openEventInCalendar() {
        guard let identifier = assignment?.eventIdentifier else { return }
        let eventStore = EKEventStore()
        let event = eventStore.event(withIdentifier: identifier)
        guard let interval = event?.startDate.timeIntervalSinceReferenceDate else { return }
        guard let url = URL(string: "calshow:\(interval)") else { return }
        UIApplication.shared.open(url)
    }
}
