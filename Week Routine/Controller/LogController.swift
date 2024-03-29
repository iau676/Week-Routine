//
//  LogController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 30.04.2023.
//

import UIKit

private let reuseIdentifier = "LogCell"

protocol LogControllerDelegate: AnyObject {
    func updateCV()
}

final class LogController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: LogControllerDelegate?
    private let routine: Routine
    private lazy var headerView = LogHeader(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
    private let tableView = UITableView()
    private let placeholderView = PlaceholderView(text: "No Data")
    
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
        view.backgroundColor = Colors.backgroundColor
        
        headerView.routine = routine
        headerView.delegate = self
        tableView.tableHeaderView = headerView
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
    
    private func updatePlaceholderViewVisibility(){
        view.addSubview(placeholderView)
        placeholderView.centerX(inView: tableView)
        placeholderView.centerY(inView: tableView)
        placeholderView.isHidden = routine.logArray.count != 0
    }
}

//MARK: - UITableViewDataSource

extension LogController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updatePlaceholderViewVisibility()
        return routine.logArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LogCell
        cell.log = routine.logArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//MARK: - UITableViewDelegate

extension LogController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let log = self.routine.logArray[indexPath.row]
            if let date = log.date {
                self.showActionSheet(title: "'\(date.getFormattedDate(format: DateFormat.LogDelete))' will be deleted", message: "This action cannot be undone", actionTitle: "Delete", style: .destructive) {
                    brain.deleteLog(self.routine, indexPath.row)
                    self.routineChanged()
                    self.delegate?.updateCV()
                    tableView.reloadData()
                }
                success(true)
            }
        })
        deleteAction.setImage(image: Images.bin, width: 25, height: 25)
        deleteAction.setBackgroundColor(.systemRed)

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

//MARK: - LogHeaderDelegate

extension LogController: LogHeaderDelegate {
    func routineChanged() {
        headerView.routine = routine
    }
}
