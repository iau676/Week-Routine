//
//  ViewController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 5.10.2022.
//

import UIKit

private let reuseIdentifier = "RoutineCell"

final class RoutineController: UIViewController {

    private let routineCV = makeCollectionView()
    private let placeholderView = PlaceholderView(text: "No Routine")
    private let daySegmentedControl = UISegmentedControl()
    private var tempArray = [Int]() { didSet { routineCV.reloadData() } }
        
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        updateCV()
        addGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        brain.askNotificationPermission()
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
    
    @objc private func daySegmentedControlChanged(segment: UISegmentedControl) -> Void {
        findWhichRoutinesShouldShow()
    }
    
    //MARK: - Helpers
    
    private func style() {
        configureBarButton()
        view.backgroundColor = Colors.backgroundColor
        
        routineCV.delegate = self
        routineCV.dataSource = self
        routineCV.layer.cornerRadius = 8
        routineCV.backgroundColor = Colors.viewColor
        routineCV.register(RoutineCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        daySegmentedControl.replaceSegments(segments: brain.days[UDM.selectedDayType.getInt()])
        daySegmentedControl.selectedSegmentIndex = brain.getDayInt()
        daySegmentedControl.tintColor = .black
        daySegmentedControl.addTarget(self, action: #selector(self.daySegmentedControlChanged), for: .valueChanged)
    }
    
    private func layout() {
        let stack = UIStackView(arrangedSubviews: [routineCV, daySegmentedControl])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        
        view.addSubview(stack)
        daySegmentedControl.setHeight(50)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                     bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                     paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
    }
    
    private func updatePlaceholderViewVisibility(){
        view.addSubview(placeholderView)
        placeholderView.centerX(inView: routineCV)
        placeholderView.centerY(inView: routineCV)
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
    
    private func findWhichRoutinesShouldShow(){
        tempArray.removeAll()
        tempArray = brain.findRoutines(for: daySegmentedControl.selectedSegmentIndex)
        updatePlaceholderViewVisibility()
    }
    
    private func checkSelectedSegmentToday() -> Bool {
        var day = Calendar.current.component(.weekday, from: Date())
        day = (day-2 < 0) ? 6 : day-2
        return daySegmentedControl.selectedSegmentIndex == day
    }
}

//MARK: - UICollectionViewDelegate/DataSource

extension RoutineController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RoutineCell
        cell.selectedSegmentIndex = daySegmentedControl.selectedSegmentIndex
        cell.routine = brain.routineArray[tempArray[indexPath.row]]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if checkSelectedSegmentToday() {
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

//MARK: - UICollectionViewDelegateFlowLayout

extension RoutineController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((view.bounds.width)-32), height: 100)
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
        var selectedSegmentIndex = daySegmentedControl.selectedSegmentIndex
        selectedSegmentIndex = (selectedSegmentIndex + 1 > 6) ? 0 : selectedSegmentIndex + 1
        daySegmentedControl.selectedSegmentIndex = selectedSegmentIndex
        findWhichRoutinesShouldShow()
    }
        
    @objc private func respondToSwipeRight(gesture: UISwipeGestureRecognizer) {
        var selectedSegmentIndex = daySegmentedControl.selectedSegmentIndex
        selectedSegmentIndex = (selectedSegmentIndex - 1 < 0) ? 6 : selectedSegmentIndex - 1
        daySegmentedControl.selectedSegmentIndex = selectedSegmentIndex
        findWhichRoutinesShouldShow()
    }
}

//MARK: - UpdateDelegate

extension RoutineController: UpdateDelegate {
    func updateCV() {
        brain.loadRoutineArray()
        findWhichRoutinesShouldShow()
    }
}

//MARK: - SettingsDelegate

extension RoutineController: SettingsDelegate {
    func updateSettings() {
        daySegmentedControl.replaceSegments(segments: brain.days[UDM.selectedDayType.getInt()])
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
        routineCV.reloadData()
    }
}
