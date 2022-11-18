//
//  ViewController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 5.10.2022.
//

import UIKit

class ViewController: UIViewController, UpdateDelegate, SettingsDelegate {
        
    var tempArray = [Int]()
    var selectedSegmentIndex = 0
    var routineArray: [Routine] { return RoutineBrain.shareInstance.routineArray }
    
    let stackView = UIStackView()
    let tableView = UITableView()
    let daySegmentedControl = UISegmentedControl()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Week Routine"
        style()
        layout()
        configureBarButton()
        configureSettingsButton()
        updateTableView()
        
        getWeekday()
        findWhichRoutinesShouldShow()
        askNotificationPermission()
        addGestureRecognizer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: - Helpers
    
    func addGestureRecognizer(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeLeftGesture))
        swipeLeft.direction = .left
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeRightGesture))
        swipeRight.direction = .right
        
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
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
        findWhichRoutinesShouldShow()
    }
    
    func updateSettings() {
        daySegmentedControl.replaceSegments(segments: RoutineBrain.shareInstance.days[UserDefault.selectedDayType.getInt()])
        getWeekday()
    }
    
    func getWeekday() {
        var weekday = Calendar.current.component(.weekday, from: Date())
        weekday = (weekday-2 < 0) ? 6 : weekday-2
        selectedSegmentIndex = weekday
        daySegmentedControl.selectedSegmentIndex = weekday
    }
    
    func findWhichRoutinesShouldShow(){
        
        tempArray.removeAll()
        
        let array = RoutineBrain.shareInstance.routineArray
        
        for i in 0..<array.count {
            switch selectedSegmentIndex {
            case 0:
                if array[i].day == 1 || array[i].day == 0  { tempArray.append(i) }
                break
            case 1:
                if array[i].day == 2 || array[i].day == 0 { tempArray.append(i) }
                break
            case 2:
                if array[i].day == 3 || array[i].day == 0 { tempArray.append(i) }
                break
            case 3:
                if array[i].day == 4 || array[i].day == 0 { tempArray.append(i) }
                break
            case 4:
                if array[i].day == 5 || array[i].day == 0 { tempArray.append(i) }
                break
            case 5:
                if array[i].day == 6 || array[i].day == 0 { tempArray.append(i) }
                break
            case 6:
                if array[i].day == 7 || array[i].day == 0 { tempArray.append(i) }
                break
            default:
                break
            }
        }
        self.tableView.reloadData()
    }
    
    func askNotificationPermission(){
        RoutineBrain.shareInstance.notificationCenter.requestAuthorization(options: [.alert, .sound]) {
            (permissionGranted, error) in
            if(!permissionGranted){
                print("Permission Denied")
            }
        }
    }
    
    //MARK: - Selectors
    
    @objc func respondToSwipeLeftGesture(gesture: UISwipeGestureRecognizer) {
        selectedSegmentIndex = (selectedSegmentIndex - 1 < 0) ? 6 : selectedSegmentIndex - 1
        daySegmentedControl.selectedSegmentIndex = selectedSegmentIndex
        findWhichRoutinesShouldShow()
    }
    
    @objc func respondToSwipeRightGesture(gesture: UISwipeGestureRecognizer) {
        selectedSegmentIndex = (selectedSegmentIndex + 1 > 6) ? 0 : selectedSegmentIndex + 1
        daySegmentedControl.selectedSegmentIndex = selectedSegmentIndex
        findWhichRoutinesShouldShow()
    }
    
    @objc func addButtonPressed() {
        let vc = AddViewController()
        vc.delegate = self
        vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(vc, animated: true)
    }
    
    @objc func settingsButtonPressed() {
        let vc = SettingsViewController()
        vc.delegate = self
        vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(vc, animated: true)
    }
    
    @objc private func daySegmentedControlChanged(segment: UISegmentedControl) -> Void {
        selectedSegmentIndex = segment.selectedSegmentIndex
        findWhichRoutinesShouldShow()
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
        daySegmentedControl.replaceSegments(segments: RoutineBrain.shareInstance.days[UserDefault.selectedDayType.getInt()])
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
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: self.topbarHeight+40),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 3)
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
        return tempArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
        
        let item = RoutineBrain.shareInstance.routineArray[tempArray[indexPath.row]]
        
        var day = ""
        
        switch item.day {
            case 0:
            day = "Every day"
                break
            case 1:
            day = "Monday"
                break
            case 2:
            day = "Tuesday"
                break
            case 3:
            day = "Wednesday"
                break
            case 4:
            day = "Thursday"
                break
            case 5:
            day = "Friday"
                break
            case 6:
            day = "Saturday"
                break
            case 7:
            day = "Sunday"
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.6, delay: 0.06 * Double(indexPath.row), animations: {
            cell.alpha = 1
        })
    }
}

//MARK: - Swipe Cell

extension ViewController {
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let alert = UIAlertController(title: "Routine will be deleted", message: "This action cannot be undone", preferredStyle: .alert)
            let actionDelete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                RoutineBrain.shareInstance.removeRoutine(at: self.tempArray[indexPath.row])
                self.findWhichRoutinesShouldShow()
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
