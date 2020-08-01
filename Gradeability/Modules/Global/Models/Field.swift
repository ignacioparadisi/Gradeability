//
//  Field.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import Combine

enum FieldType {
    case largeTextField
    case decimalTextField
    case datePicker
    case `switch`
    case circularPicker
    case destructiveButton
    case button
}

protocol FieldRepresentable {
    var title: String  { get }
    var placeholder: String?  { get }
    var stringValue: String? { get set }
    var type: FieldType { get }
}

class ButtonField: FieldRepresentable {
    var title: String
    var placeholder: String?
    var stringValue: String?
    var type: FieldType
    
    init(title: String, type: FieldType = .button) {
        self.title = title
        self.type = type
    }
}

class Field<Coder: StringCoder>: FieldRepresentable {
    var title: String
    var placeholder: String?
    var stringValue: String?
    @Published var value: Coder.T?
    var type: FieldType
    
    init(title: String, placeholder: String? = nil, value: Coder.T? = nil, type: FieldType) {
        self.title = title
        self.placeholder = placeholder
        self.value = value
        self.stringValue = Coder.encode(value: value)
        self.type = type
    }
}
