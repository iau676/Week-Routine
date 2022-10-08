//
//  ViewController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 5.10.2022.
//

import UIKit

class ViewController: UIViewController, UpdateDelegate {
    
    var days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var routineArray: [Routine] { return RoutineBrain.shareInstance.routineArray }
    
    let stackView = UIStackView()
    let tableView = UITableView()
    let daySegmentedControl = UISegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        title = "Week Routine"
        configureBarButton()
        configureSettingsButton()
        updateTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func configureBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = Colors.labelColor
    }
    
    func configureSettingsButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsButtonPressed))
        navigationItem.leftBarButtonItem?.tintColor = Colors.labelColor
    }
    
    func updateTableView() {
        RoutineBrain.shareInstance.loadRoutineArray()
        self.tableView.reloadData()
    }
    
    @objc func addButtonPressed() {
        let vc = AddViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    @objc func settingsButtonPressed() {
        let vc = SettingsViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    @objc private func daySegmentedControlChanged(segment: UISegmentedControl) -> Void {
        switch segment.selectedSegmentIndex {
        case 1:
            print("1")
        default:
            print("d")
        }
    }
}

//MARK: - Layout

extension ViewController {
    
    func style() {
        
        view.backgroundColor = Colors.backgroundColor
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill

        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier:CustomCell.identifier)
        tableView.backgroundColor = Colors.viewColor
        tableView.layer.cornerRadius = 8
        tableView.dataSource = self
        tableView.delegate = self
        
        daySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        daySegmentedControl.replaceSegments(segments: days)
        daySegmentedControl.selectedSegmentIndex = 0
        daySegmentedControl.tintColor = .black
        daySegmentedControl.addTarget(self, action: #selector(self.daySegmentedControlChanged), for: UIControl.Event.valueChanged)
       
    }
    
    func layout() {
        
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(daySegmentedControl)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationController!.navigationBar.frame.height+25),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 2)
        ])
        
        NSLayoutConstraint.activate([
            daySegmentedControl.heightAnchor.constraint(equalTo: tableView.heightAnchor, multiplier: 0.08)
        ])
    }
}

//MARK: - Show Routine

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routineArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
        
        let item = RoutineBrain.shareInstance.routineArray[indexPath.row]
        
        var day = ""
        
        switch item.day {
            case 0:
            day = "Every day"
                break
            case 1:
            day = "Sunday"
                break
            case 2:
            day = "Monday"
                break
            case 3:
            day = "Tuesday"
                break
            case 4:
            day = "Wednesday"
                break
            case 5:
            day = "Thursday"
                break
            case 6:
            day = "Friday"
                break
            case 7:
            day = "Saturday"
                break
            default:
                break
        }
        
        let hour = item.hour < 10 ? "0\(item.hour)" : "\(item.hour)"
        let minute = item.minute < 10 ? "0\(item.minute)" : "\(item.minute)"

        cell.titleLabel.text = item.title
        cell.dateLabel.text = "\(day), \(hour):\(minute)"
        cell.titleLabel.textColor = Colors.labelColor
    
        return cell
    }
}

//MARK: - Swipe Cell

extension ViewController {
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let alert = UIAlertController(title: "Routine will be deleted", message: "This action cannot be undone", preferredStyle: .alert)
            let actionDelete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                RoutineBrain.shareInstance.removeRoutine(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(actionDelete)
            alert.addAction(actionCancel)
            self.present(alert, animated: true, completion: nil)
            success(true)
        })
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
