//
//  TaskItem.swift
//  TaskManager
//
//  Created by Cem Ege on 6.08.2025.
//

import Foundation

struct TaskItem {
    var t: String
    var d: String
    var isDone: Bool
    var id: Int
    var createdAt: String
    
    init(t: String, d: String, isDone: Bool = false, id: Int, createdAt: String) {
        self.t = t
        self.d = d
        self.isDone = isDone
        self.id = id
        self.createdAt = createdAt
    }
    
    mutating func toggle() {
        self.isDone = !self.isDone
    }
    
    func getDisplayText() -> String {
        let status = isDone ? "✅" : "❌"
        return "\(status) \(t) - \(d)"
    }
}

func createNewTask(title: String, desc: String) -> TaskItem {
    let currentDate = "2025-08-06"
    let newId = Int.random(in: 1...1000)
    
    return TaskItem(t: title, d: desc, isDone: false, id: newId, createdAt: currentDate)
}
