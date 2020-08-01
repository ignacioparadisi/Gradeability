//
//  StringCoder.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol StringCoder {
    associatedtype T
    static func decode(string: String?) -> T?
    static func encode(value: T?) -> String?
}

extension String: StringCoder {
    typealias T = String
    static func decode(string: String?) -> String? {
        return string
    }
    static func encode(value: String?) -> String? {
        return value
    }
}

extension Float: StringCoder {
    typealias T = Float
    static func decode(string: String?) -> Float? {
        guard let string = string else { return nil }
        return Float(string)
    }
    static func encode(value: Float?) -> String? {
        guard let value = value else { return nil }
        return "\(value)"
    }
}

extension Date: StringCoder {
    typealias T = Date
    static func decode(string: String?) -> Date? {
        guard let string = string else { return nil }
        let dateFormatter: DateFormatter = .longDateShortTimeDateFormatter
        return dateFormatter.date(from: string)
    }
    static func encode(value: Date?) -> String? {
        guard let value = value else { return nil }
        let dateFormatter: DateFormatter = .longDateShortTimeDateFormatter
        return dateFormatter.string(from: value)
    }
}

extension Bool: StringCoder {
    typealias T = Bool
    static func decode(string: String?) -> Bool? {
        guard let string = string else { return nil }
        return string == "1"
    }
    static func encode(value: Bool?) -> String? {
        guard let value = value else { return nil }
        return value ? "1" : "0"
    }
}
