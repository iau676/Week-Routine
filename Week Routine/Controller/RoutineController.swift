//
//  ViewController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 5.10.2022.
//

import UIKit

private let reuseIdentifier = "RoutineCell"

final class RoutineController: UIViewController {

    private let headerView = FilterView()
    private let tableView = UITableView()
    private let placeholderView = PlaceholderView(text: "No Routine")
    private var tempArray = [Int]() { didSet { tableView.reloadData() } }
    private var currrentIndex = 0 { didSet { tableView.reloadData() } }
        
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        updateCV()
        addGestureRecognizer()
        findWhichRoutinesShouldShow(for: brain.getDayInt())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        brain.askNotificationPermission()
        headerView.updateSelected(for: brain.getDayInt())
        tableView.reloadData()
    }
    
    //MARK: - Selectors
    
    @objc private func addButtonPressed() {
        let controller = AddController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .formSheet
        self.present(nav, animated: true)
    }
    
    @objc private func settingsButtonPressed() {
        let vc = SettingsController()
        vc.delegate = self
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true)
    }

    //MARK: - Helpers
    
    private func style() {
        configureBarButton()
        view.backgroundColor = Colors.backgroundColor
        
        headerView.setDimensions(width: view.frame.width, height: 50)
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        tableView.rowHeight = 99
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 8
        tableView.alwaysBounceVertical = false
        tableView.backgroundColor = Colors.viewColor
        tableView.register(RoutineCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    private func layout() {
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    private func updatePlaceholderViewVisibility(){
        view.addSubview(placeholderView)
        placeholderView.centerX(inView: tableView)
        placeholderView.centerY(inView: tableView)
        placeholderView.isHidden = tempArray.count != 0
    }
        
    private func configureBarButton() {
        title = "Week Routine"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = Colors.labelColor
        
        let leftBarIV = UIImageView()
        leftBarIV.setDimensions(width: 20, height: 20)
        leftBarIV.layer.masksToBounds = true
        leftBarIV.isUserInteractionEnabled = true
        
        leftBarIV.image = Images.menu?.withTintColor(Colors.labelColor ?? .black, renderingMode: .alwaysOriginal)
        let tapLeft = UITapGestureRecognizer(target: self, action: #selector(settingsButtonPressed))
        leftBarIV.addGestureRecognizer(tapLeft)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarIV)
    }
    
    private func findWhichRoutinesShouldShow(for index: Int) {
        currrentIndex = index
        tempArray.removeAll()
        tempArray = brain.findRoutines(for: index)
        updatePlaceholderViewVisibility()
    }
}

//MARK: - UITableViewDataSource

extension RoutineController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RoutineCell
        cell.selectedSegmentIndex = currrentIndex
        cell.routine = brain.routineArray[tempArray[indexPath.row]]
        cell.delegate = self
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return size(forText: tempArray[indexPath.row].description).height + 50
//    }
}

//MARK: - UITableViewDelegate

extension RoutineController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if currrentIndex == brain.getDayInt() {
            let routine = brain.routineArray[tempArray[indexPath.row]]
            let controller = CompleteController(routine: routine)
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .formSheet
            self.present(nav, animated: true)
        } else {
            self.showAlertWithTimer(title: "Not Today")
        }
    }
}

//MARK: - Swipe Gesture

extension RoutineController {
    private func addGestureRecognizer(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeLeft))
        swipeLeft.direction = .left
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeRight))
        swipeRight.direction = .right
        
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc private func respondToSwipeLeft(gesture: UISwipeGestureRecognizer) {
        currrentIndex = (currrentIndex + 1 > 6) ? 0 : currrentIndex + 1
        findWhichRoutinesShouldShow(for: currrentIndex)
        headerView.updateSelected(for: currrentIndex)
    }
        
    @objc private func respondToSwipeRight(gesture: UISwipeGestureRecognizer) {
        currrentIndex = (currrentIndex - 1 < 0) ? 6 : currrentIndex - 1
        findWhichRoutinesShouldShow(for: currrentIndex)
        headerView.updateSelected(for: currrentIndex)
    }
}

//MARK: - UpdateDelegate

extension RoutineController: UpdateDelegate {
    func updateCV() {
        brain.loadRoutineArray()
        findWhichRoutinesShouldShow(for: currrentIndex)
    }
}

//MARK: - SettingsDelegate

extension RoutineController: SettingsDelegate {
    func updateSettings() {
//        daySegmentedControl.replaceSegments(segments: brain.days[UDM.selectedDayType.getInt()])
    }
}

//MARK: - RoutineCellDelegate

extension RoutineController: RoutineCellDelegate {
    func goLog(routine: Routine) {
        let controller = LogController(routine: routine)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .formSheet
        self.present(nav, animated: true)
    }
    
    func goEdit(routine: Routine) {
        let controller = AddController()
        controller.delegate = self
        controller.routine = routine
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .formSheet
        self.present(nav, animated: true)
    }
}

//MARK: - CompleteControllerDelegate

extension RoutineController: CompleteControllerDelegate {
    func updateTableView() {
        tableView.reloadData()
    }
}

//MARK: - FilterViewDelegate

extension RoutineController: FilterViewDelegate {
    func filterView(_ view: FilterView, didSelect index: Int) {
        findWhichRoutinesShouldShow(for: index)
    }
}
