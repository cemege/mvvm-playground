//
//  TaskItem.swift
//  TaskManager
//
//  Created by Cem Ege on 6.08.2025.
//

import Foundation

struct TaskItem: Equatable {
    let id: String = UUID().uuidString
    let title: String
    let description: String
    var isTaskDone: Bool
    let createdAt: String
}
