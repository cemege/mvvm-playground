//
//  ViewController.swift
//  TaskManager
//
//  Created by Cem Ege on 6.08.2025.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    var tableView: UITableView!
    var taskCountLabel: UILabel!
    var addButton: UIButton!
    var titleTextField: UITextField!
    var descTextField: UITextField!
    var searchBar: UISearchBar!
    
    var viewModel: TaskViewModel!
    
    let cellHeight: CGFloat = 60.0
    let buttonHeight: CGFloat = 44.0
    let textFieldHeight: CGFloat = 40.0
    let padding: CGFloat = 16.0
    
    var isSearching = false
    var filteredTasks: [TaskItem] = []
    var currentEditingIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupUI()
        setupTableView()
        setupConstraints()
        setupNotifications()
        loadInitialData()
        
        view.backgroundColor = .white
        title = "Task Manager"
    }
    
    func setupViewModel() {
        viewModel = TaskViewModel()
        viewModel.viewController = self
    }
    
    func setupUI() {
        taskCountLabel = UILabel()
        taskCountLabel.text = "0/100 tasks"
        taskCountLabel.textAlignment = .center
        taskCountLabel.font = UIFont.systemFont(ofSize: 16)
        taskCountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(taskCountLabel)
        
        titleTextField = UITextField()
        titleTextField.placeholder = "Enter task title"
        titleTextField.borderStyle = .roundedRect
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleTextField)
        
        descTextField = UITextField()
        descTextField.placeholder = "Enter description"
        descTextField.borderStyle = .roundedRect
        descTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descTextField)
        
        addButton = UIButton(type: .system)
        addButton.setTitle("Add Task", for: .normal)
        addButton.backgroundColor = .systemBlue
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 8
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        view.addSubview(addButton)
        
        searchBar = UISearchBar()
        searchBar.placeholder = "Search tasks..."
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        taskCountLabel.accessibilityLabel = "task count"
        titleTextField.accessibilityLabel = "title field"
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = viewModel
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            taskCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            taskCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            taskCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            taskCountLabel.heightAnchor.constraint(equalToConstant: 30),
            
            searchBar.topAnchor.constraint(equalTo: taskCountLabel.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            titleTextField.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            descTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            descTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            addButton.topAnchor.constraint(equalTo: descTextField.bottomAnchor, constant: 10),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            tableView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func loadInitialData() {
        updateTaskCount()
    }
    
    @objc func addButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty,
              let desc = descTextField.text, !desc.isEmpty else {
            showAlert(title: "Error", message: "Please fill all fields")
            return
        }
        
        viewModel.addNewTask(title: title, desc: desc)
        
        titleTextField.text = ""
        descTextField.text = ""
        titleTextField.resignFirstResponder()
        descTextField.resignFirstResponder()
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: point) {
                showDeleteAlert(for: indexPath.row)
            }
        }
    }
    
    func showDeleteAlert(for index: Int) {
        let alert = UIAlertController(title: "Delete Task", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.viewModel.deleteTask(at: index)
        })
        present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func updateTaskCount() {
        taskCountLabel.text = viewModel.getTaskCount()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -keyboardHeight/2
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.toggleTask(at: indexPath.row)
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredTasks.removeAll()
        } else {
            isSearching = true
            filteredTasks = viewModel.searchTasks(query: searchText)
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

