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
    private let placeholderView = PlaceholderView()
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
}

//MARK: - UICollectionViewDelegate/DataSource

extension RoutineController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RoutineCell
        cell.routine = brain.routineArray[tempArray[indexPath.row]]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        brain.updateRoutineState(routine: brain.routineArray[tempArray[indexPath.row]])
//        routineCV.reloadData()
        let routine = brain.routineArray[tempArray[indexPath.row]]
        let controller = CompleteController(routine: routine)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .formSheet
        self.present(nav, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension RoutineController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((view.bounds.width)-32), height: 100)
    }
}


//MARK: - Swipe Cell

//extension ViewController {
//    func tableView(_ tableView: UITableView,
//                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//            let alert = UIAlertController(title: "Routine will be deleted", message: "This action cannot be undone", preferredStyle: .alert)
//            let actionDelete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
//                RoutineBrain.shareInstance.removeRoutine(at: self.tempArray[indexPath.row])
//                self.findWhichRoutinesShouldShow()
//            }
//            let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
//                alert.dismiss(animated: true, completion: nil)
//            }
//            alert.addAction(actionDelete)
//            alert.addAction(actionCancel)
//            self.present(alert, animated: true, completion: nil)
//            success(true)
//        })
//        deleteAction.setImage(image: Images.bin, width: 21, height: 21)
//
//        let editAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//            let vc = AddViewController()
//            let item = RoutineBrain.shareInstance.routineArray[self.tempArray[indexPath.row]]
//            vc.delegate = self
//            vc.isEditMode = true
//            vc.routineTitle = item.title ?? ""
//            vc.dayInt = Int(item.day)
//            vc.hour = "\(item.hour)"
//            vc.minute = "\(item.minute)"
//            vc.colorName = item.color ?? ""
//            vc.routineArrayIndex = self.tempArray[indexPath.row]
//            vc.modalPresentationStyle = .overCurrentContext
//            self.present(vc, animated: true)
//            success(true)
//        })
//        editAction.setImage(image: Images.edit, width: 21, height: 21)
//        editAction.setBackgroundColor(Colors.blue)
//
//        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
//    }
//}

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
