//
//  CalendarView.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/10/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarView: JTACMonthView {
    
    override init() {
        super.init()
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        isPagingEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
