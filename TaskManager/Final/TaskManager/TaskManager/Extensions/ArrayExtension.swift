//
//  ArrayExtension.swift
//  TaskManager
//
//  Created by Cem Ege on 6.08.2025.
//

import Foundation

extension Array where Element: Equatable {
    subscript (safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}
