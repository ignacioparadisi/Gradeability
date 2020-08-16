//
//  DateFormatter+Extension.swift
//  Recademic
//
//  Created by Ignacio Paradisi on 7/26/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

extension DateFormatter {
    static var longDateShortTimeDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
}
