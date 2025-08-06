//
//  TaskViewModel.swift
//  TaskManager
//
//  Created by Cem Ege on 6.08.2025.
//

import Foundation
import UIKit

protocol TaskViewModelProtocol {
    
}

class TaskViewModel: NSObject {
    
    var tasks: [TaskItem] = []
    
    weak var viewController: ViewController?
    
    let maxTasks = 100
    var currentCount = 0
    
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
        tasks.append(TaskItem(t: "Buy groceries", d: "Get milk and bread", isDone: false, id: 1, createdAt: "2025-08-06"))
        tasks.append(TaskItem(t: "Walk the dog", d: "Take Rex for a walk", isDone: true, id: 2, createdAt: "2025-08-06"))
        tasks.append(TaskItem(t: "Finish project", d: "Complete the iOS app", isDone: false, id: 3, createdAt: "2025-08-06"))
    }
    
    func addNewTask(title: String, desc: String) {
        if title.count > 0 && desc.count > 0 {
            let newTask = createNewTask(title: title, desc: desc)
            tasks.append(newTask)
            currentCount += 1
            
            DispatchQueue.main.async {
                self.viewController?.tableView.reloadData()
                self.viewController?.updateTaskCount()
            }
        }
    }
    
    func deleteTask(at index: Int) {
        if index >= 0 && index < tasks.count {
            tasks.remove(at: index)
            currentCount -= 1
            viewController?.tableView.reloadData()
            viewController?.updateTaskCount()
        }
    }
    
    func toggleTask(at index: Int) {
        if index < tasks.count {
            tasks[index].toggle()
            viewController?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
    
    func getTaskCount() -> String {
        return "\(tasks.count)/\(maxTasks) tasks"
    }
    
    func searchTasks(query: String) -> [TaskItem] {
        var results: [TaskItem] = []
        for task in tasks {
            if task.t.contains(query) || task.d.contains(query) {
                results.append(task)
            }
        }
        return results
    }
    
}

extension TaskViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = tasks[indexPath.row]
        
        cell.textLabel?.text = task.getDisplayText()
        cell.textLabel?.textColor = task.isDone ? .gray : .black
        
        return cell
    }
}
