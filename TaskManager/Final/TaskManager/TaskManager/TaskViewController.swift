//
//  TaskViewController.swift
//  TaskManager
//
//  Created by Cem Ege on 6.08.2025.
//

import UIKit

protocol TaskViewControllerInterface: AnyObject {
    
    func reloadTableView()
    func reloadRow(at indexPath: IndexPath)
    func updateTaskCountDisplayText()
}

final class TaskViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: TaskViewModelInterface
    
    // UI Components as lazy vars
    private lazy var taskCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/100 tasks"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityLabel = "task count"
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter task title"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityLabel = "titleTextField"
        textField.doneInputAccessory()
        return textField
    }()
    
    private lazy var descTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter description"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.doneInputAccessory()
        return textField
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Task", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search tasks..."
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.doneInputAccessory()
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressGesture)
        
        return tableView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: TaskViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        loadInitialData()
        viewModel.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Task Manager"
    }
}

// MARK: - UI Setup
private extension TaskViewController {
    func setupUI() {
        view.addSubview(taskCountLabel)
        view.addSubview(titleTextField)
        view.addSubview(descTextField)
        view.addSubview(addButton)
        view.addSubview(searchBar)
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
            titleTextField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight.rawValue),
            
            descTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            descTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descTextField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight.rawValue),
            
            addButton.topAnchor.constraint(equalTo: descTextField.bottomAnchor, constant: 10),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight.rawValue),
            
            tableView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func loadInitialData() {
        updateTaskCountDisplayText()
    }
}

// MARK: - Actions
private extension TaskViewController {
    @objc
    func addButtonTapped() {
        view.resignFirstResponder()
        
        guard let title = titleTextField.text, !title.isEmpty,
              let description = descTextField.text, !description.isEmpty else {
            showAlert(title: "Error", message: "Please fill all fields")
            return
        }
        
        viewModel.addNewTask(title: title, description: description)
        
        titleTextField.text = ""
        descTextField.text = ""
    }
    
    @objc
    func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: point) {
                showDeleteAlert(for: indexPath.row)
            }
        }
    }
}

// MARK: - Alert Configuration
private extension TaskViewController {
    func showDeleteAlert(for index: Int) {
        let alert = UIAlertController(title: "Delete Task", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self else { return }
            viewModel.deleteTask(at: index)
        })
        
        present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - TaskViewController Interface
extension TaskViewController: TaskViewControllerInterface {
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func reloadRow(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func updateTaskCountDisplayText() {
        taskCountLabel.text = viewModel.getTaskCountText()
    }
}

// MARK: - SearchBar Configuration
extension TaskViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource
extension TaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.taskCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = viewModel.getTask(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        cell.textLabel?.text = viewModel.getDisplayText(task)
        cell.textLabel?.textColor = task?.isTaskDone ?? false ? .gray : .black
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIConstants.cellHeight.rawValue
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.toggleTask(at: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - Constants
extension TaskViewController {
    enum UIConstants: CGFloat {
        case cellHeight = 60.0
        case buttonHeight = 44.0
        case textFieldHeight = 40.0
        case padding = 16.0
    }
}
