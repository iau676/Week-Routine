//
//  LogController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 30.04.2023.
//

import UIKit

private let reuseIdentifier = "LogCell"

final class LogController: UIViewController {
    
    //MARK: - Properties
    
    private let routine: Routine
    private let tableView = UITableView()
    
    //MARK: - Lifecycle
    
    init(routine: Routine) {
        self.routine = routine
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
    
    //MARK: - Helpers
    
    private func style() {
        title = routine.title
        view.backgroundColor = .systemGroupedBackground
        
        tableView.allowsSelection = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.tableFooterView = UIView()
        tableView.register(LogCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func layout() {
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
}

//MARK: - UITableViewDataSource

extension LogController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routine.logArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LogCell
        cell.log = routine.logArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return size(forText: routine.logArray[indexPath.row].content).height + 50
    }
}

//MARK: - UITableViewDelegate

extension LogController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.showDeleteAlert(title: "Data will be deleted", message: "This action cannot be undone") { _ in
                brain.deleteLog(self.routine, indexPath.row)
                tableView.reloadData()
            }
            success(true)
        })
        deleteAction.setImage(image: Images.bin, width: 25, height: 25)
        deleteAction.setBackgroundColor(.systemRed)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
