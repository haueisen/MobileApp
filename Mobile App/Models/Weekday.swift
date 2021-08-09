//
//  Weekday.swift
//  Mobile App
//
//  Created by flavio on 08/08/21.
//

import Foundation

enum Weekday: Int, CaseIterable {
    case monday = 0
    case tuesday = 1
    case wednesday = 2
    case thursday = 3
    case friday = 4
    case saturday = 5
    case sunday = 6

    var abbreviation: String {
        switch self {
        case .monday:
            return NSLocalizedString("monday_abbrev", comment: "")
        case .tuesday:
            return NSLocalizedString("tuesday_abbrev", comment: "")
        case .wednesday:
            return NSLocalizedString("wednesday_abbrev", comment: "")
        case .thursday:
            return NSLocalizedString("thursday_abbrev", comment: "")
        case .friday:
            return NSLocalizedString("friday_abbrev", comment: "")
        case .saturday:
            return NSLocalizedString("saturday_abbrev", comment: "")
        case .sunday:
            return NSLocalizedString("sunday_abbrev", comment: "")
        }
    }
}
