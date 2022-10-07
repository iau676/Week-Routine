//
//  ViewController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 5.10.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var routineArray: [Routine] { return RoutineBrain.shareInstance.routineArray }
    
    let stackView = UIStackView()
    let label = UILabel()
    
    let tableView = UITableView()
    let daySegmentedControl = UISegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        title = "Week Routine"
        configureBarButton()
        configureSettingsButton()
        RoutineBrain.shareInstance.loadRoutineArray()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func configureBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    func configureSettingsButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsButtonPressed))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    @objc func addButtonPressed() {
        let vc = AddViewController()
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
        
        view.backgroundColor = UIColor(hex: "#d6d6d6")
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Date Format"
        label.numberOfLines = 1
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.backgroundColor = .darkGray
        tableView.layer.cornerRadius = 8
        tableView.dataSource = self
        tableView.delegate = self

        tableView.reloadData()
        
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routineArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        cell.configure(title: routineArray[indexPath.row].title!, content: "r")
        return cell
    }

}
