//
//  DateExtension.swift
//  TaskManager
//
//  Created by Cem Ege on 6.08.2025.
//

import Foundation

extension Date {
    static func today() -> String {
        let now = Date.now
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: now)
    }
}
