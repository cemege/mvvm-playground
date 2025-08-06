//
//  TaskViewModel.swift
//  TaskManager
//
//  Created by Cem Ege on 6.08.2025.
//

import Foundation
import UIKit

protocol TaskViewModelInterface: AnyObject {
    var taskCount: Int { get }
    
    func getTaskCountText() -> String
    func getTask(at index: Int) -> TaskItem?
    func getDisplayText(_ task: TaskItem?) -> String
    
    // MARK: - Actions
    func toggleTask(at index: Int)
    func addNewTask(title: String, description: String)
    func deleteTask(at index: Int)
    func search(query: String)
    
    // MARK: - LifeCycle
    func viewDidLoad()
}

final class TaskViewModel {
    
    // MARK: - Properties
    private var tasks: [TaskItem] = []
    private let maxTasks = 100
    
    private var searchWorkItem: DispatchWorkItem?
    private var isSearching = false
    private var searchedTasks: [TaskItem] = []
    
    weak var viewController: TaskViewControllerInterface?
    
    func loadData() {
        tasks.append(TaskItem(title: "Buy groceries", description: "Get milk and bread", isTaskDone: false, createdAt: "2025-08-06"))
        tasks.append(TaskItem(title: "Walk the dog", description: "Take Rex for a walk", isTaskDone: true, createdAt: "2025-08-06"))
        tasks.append(TaskItem(title: "Finish project", description: "Complete the iOS app", isTaskDone: false, createdAt: "2025-08-06"))
    }
}

// MARK: - Protocol Helper
extension TaskViewModel: TaskViewModelInterface {
    var taskCount: Int {
        return isSearching ? self.searchedTasks.count : self.tasks.count
    }
    
    func viewDidLoad() {
        loadData()
    }
    
    func getTaskCountText() -> String {
        return isSearching ? "\(searchedTasks.count) of \(tasks.count) tasks" : "\(tasks.count)/\(maxTasks) tasks"
    }
    
    func getTask(at index: Int) -> TaskItem? {
        let currentTasks = isSearching ? self.searchedTasks : self.tasks
        guard currentTasks.indices.contains(index) else { return nil }
        return currentTasks[index]
    }
    
    func getDisplayText(_ task: TaskItem?) -> String {
        guard let task else { return "" }
        let status = task.isTaskDone ? "✅" : "❌"
        return "\(status) \(task.title) - \(task.description)"
    }
    
    func toggleTask(at index: Int) {
        if isSearching {
            guard searchedTasks.indices.contains(index) else { return }
            let searchedTask = searchedTasks[index]
            
            if let originalIndex = tasks.firstIndex(where: { $0.id == searchedTask.id }) {
                tasks[originalIndex].isTaskDone.toggle()
                searchedTasks[index].isTaskDone.toggle()
            }
        } else {
            guard tasks.indices.contains(index) else { return }
            tasks[index].isTaskDone.toggle()
        }
        
        viewController?.reloadTableView()
    }
    
    func addNewTask(title: String, description: String) {
        let newTask = TaskItem(
            title: title,
            description: description,
            isTaskDone: false,
            createdAt: Date.today()
        )
        
        tasks.append(newTask)
        
        viewController?.updateTaskCountDisplayText()
        viewController?.reloadTableView()
    }
    
    func deleteTask(at index: Int) {
        if isSearching {
            guard searchedTasks.indices.contains(index) else { return }
            let taskToDelete = searchedTasks[index]
            
            if let originalIndex = tasks.firstIndex(where: { $0.id == taskToDelete.id }) {
                tasks.remove(at: originalIndex)
            }
            
            searchedTasks.remove(at: index)
        } else {
            guard tasks.indices.contains(index) else { return }
            tasks.remove(at: index)
        }
        
        viewController?.reloadTableView()
        viewController?.updateTaskCountDisplayText()
    }
    
    func search(query: String) {
        searchWorkItem?.cancel()
        
        searchWorkItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            self.performSearch(query: query)
        }
        
        guard let searchWorkItem else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: searchWorkItem)
    }
    
    private func performSearch(query: String) {
        defer {
            viewController?.updateTaskCountDisplayText()
            viewController?.reloadTableView()
        }
        
        if query.isEmpty {
            isSearching = false
            searchedTasks.removeAll()
            return
        }
        
        isSearching = true
        self.searchedTasks = filterTasksBy(query: query)
    }
    
    private func filterTasksBy(query: String) -> [TaskItem] {
        let lowercaseQuery = query.lowercased()
        return tasks.filter { task in
            task.title.lowercased().contains(lowercaseQuery) || task.description.lowercased().contains(lowercaseQuery)
        }
    }
}
