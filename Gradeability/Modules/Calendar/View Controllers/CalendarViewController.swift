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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(calendarView)
        calendarView.anchor
            .topToSuperview(constant: 10, toSafeArea: true)
            .trailingToSuperview(constant: -16, toSafeArea: true)
            .leadingToSuperview(constant: 16, toSafeArea: true)
            .height(to: calendarView.widthAnchor)
            .activate()
        
        calendarView.ibCalendarDataSource = self
        calendarView.ibCalendarDelegate = self
        calendarView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "DateCollectionViewCell")
    }
}

extension CalendarViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = Date()
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

extension CalendarViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? DateCollectionViewCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateCollectionViewCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = .label
        } else {
            cell.dateLabel.textColor = .tertiaryLabel
        }
    }
}
