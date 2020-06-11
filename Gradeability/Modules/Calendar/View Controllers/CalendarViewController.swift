//
//  CalendarViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/10/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    private let calendarView = CalendarView()
    private var calendarPortraitAnchors: Anchor!
    private var calendarLandscapeAnchors: Anchor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: nil)
        setupLeftLine()
        setupCalendarView()
    }
    
    func setupLeftLine() {
        let line = UIView()
        line.backgroundColor = .systemGray4
        view.addSubview(line)
        line.anchor
            .topToSuperview()
            .bottomToSuperview()
            .leadingToSuperview()
            .width(constant: 1)
            .activate()
    }
    
    /// Add calendar view to the view controller
    private func setupCalendarView() {
        view.addSubview(calendarView)
        calendarView.ibCalendarDataSource = self
        calendarView.ibCalendarDelegate = self
        calendarView.register(DateCollectionViewCell.self)
        
        calendarPortraitAnchors = calendarView.anchor
            .topToSuperview(constant: 20, toSafeArea: true)
            .trailingToSuperview(constant: -16, toSafeArea: true)
            .leadingToSuperview(constant: 16, toSafeArea: true)
            .height(to: calendarView.widthAnchor)
        
        calendarLandscapeAnchors = calendarView.anchor
            .topToSuperview(toSafeArea: true)
            .trailingToSuperview(toSafeArea: true)
            .leadingToSuperview(toSafeArea: true)
            .bottomToSuperview(toSafeArea: true)
        
        #if targetEnvironment(macCatalyst)
        calendarPortraitAnchors.activate()
        #else
        if view.frame.size.width < view.frame.size.height {
            calendarLandscapeAnchors.deactivate()
            calendarPortraitAnchors.activate()
        } else {
            calendarPortraitAnchors.deactivate()
            calendarLandscapeAnchors.activate()
        }
        #endif

    }
    
    private func handleDeviceOrientation() {
        if view.frame.size.width < view.frame.size.height {
            calendarPortraitAnchors.deactivate()
            calendarLandscapeAnchors.activate()
        } else {
            calendarLandscapeAnchors.deactivate()
            calendarPortraitAnchors.activate()
        }
    }
    
    #if !targetEnvironment(macCatalyst)
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        handleDeviceOrientation()
        let visibleDates = calendarView.visibleDates()
        calendarView.viewWillTransition(to: .zero, with: coordinator, anchorDate: visibleDates.monthDates.first?.date)
    }
    #endif
}

// MARK: - JTACMonthViewDataSource
extension CalendarViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.year = -5
        let startDate = Calendar.current.date(byAdding: dateComponents, to: currentDate)!
        dateComponents.year = 5
        let endDate = Calendar.current.date(byAdding: dateComponents, to: currentDate)!
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

// MARK: - JTACMonthViewDelegate
extension CalendarViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableCell(for: indexPath) as DateCollectionViewCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! DateCollectionViewCell
        cell.configure(with: cellState, forDate: date)
    }
    func calendar(_ calendar: JTACMonthView, willScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let date: Date = visibleDates.monthDates.first!.date
        let month = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyy"
        
        let year = dateFormatter.string(from: date)
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "\(month.capitalized) ", attributes:[
        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)])

         navTitle.append(NSMutableAttributedString(string: year, attributes:[
         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.light)]))

        navLabel.attributedText = navTitle
         navLabel.backgroundColor = .clear
        self.navigationItem.titleView = navLabel
    }
}
