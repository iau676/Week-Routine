//
//  ViewController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 5.10.2022.
//

import UIKit

private let reuseIdentifier = "RoutineCell"

class ViewController: UIViewController, SettingsDelegate {
        
    var tempArray = [Int]()
    var selectedSegmentIndex = 0
    var routineArray: [Routine] { return brain.routineArray }
    private var dayInt: Int { return brain.getDayInt() }

    private let routineCV = makeCollectionView()
    
    let daySegmentedControl = UISegmentedControl()
    private let todayDate = brain.getTodayDate()
    
    private let placeholderView = PlaceholderView()
        
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
        setupFirstLaunch()
    }
    
    //MARK: - Selectors
    
    @objc private func addButtonPressed() {
        goAddPage()
    }
    
    @objc private func settingsButtonPressed() {
        goSettingsPage()
    }
    
    @objc private func daySegmentedControlChanged(segment: UISegmentedControl) -> Void {
        selectedSegmentIndex = segment.selectedSegmentIndex
        findWhichRoutinesShouldShow()
    }
    
    //MARK: - Helpers
        
    func configureBarButton() {
        title = "Week Routine"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
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
    
    func updateSettings() {
        daySegmentedControl.replaceSegments(segments: brain.days[UserDefault.selectedDayType.getInt()])
        updateSegmentedControlByDay()
    }
    
    func updateSegmentedControlByDay() {
        selectedSegmentIndex = dayInt
        daySegmentedControl.selectedSegmentIndex = dayInt
    }
    
    func findWhichRoutinesShouldShow(){
        
        tempArray.removeAll()
        
        let array = brain.routineArray
        
        for i in 0..<array.count {
            switch selectedSegmentIndex {
            case 0:
                if array[i].day == 0 || array[i].day == 7 || array[i].day == 8 { tempArray.append(i) }
                break
            case 1:
                if array[i].day == 1 || array[i].day == 7 || array[i].day == 8 { tempArray.append(i) }
                break
            case 2:
                if array[i].day == 2 || array[i].day == 7 || array[i].day == 8 { tempArray.append(i) }
                break
            case 3:
                if array[i].day == 3 || array[i].day == 7 || array[i].day == 8 { tempArray.append(i) }
                break
            case 4:
                if array[i].day == 4 || array[i].day == 7 || array[i].day == 8 { tempArray.append(i) }
                break
            case 5:
                if array[i].day == 5 || array[i].day == 7 || array[i].day == 9 { tempArray.append(i) }
                break
            case 6:
                if array[i].day == 6 || array[i].day == 7 || array[i].day == 9 { tempArray.append(i) }
                break
            default:
                break
            }
        }
        updatePlaceholderViewVisibility()
        routineCV.reloadData()
    }
    
    private func updateRoutineState(at index: Int) {
        let item = brain.routineArray[tempArray[index]]
        if selectedSegmentIndex == dayInt {
            if item.isDone {
                item.isDone = false
                item.doneDate = ""
            } else {
                item.isDone = true
                item.doneDate = todayDate
            }
            brain.saveContext()
            routineCV.reloadData()
        }
    }
    
    private func setupFirstLaunch() {
        askNotificationPermission()
    }
    
    func askNotificationPermission(){
        brain.notificationCenter.requestAuthorization(options: [.alert, .sound]) {
            (permissionGranted, error) in
            if(!permissionGranted){
                print("Permission Denied")
            }
        }
    }
    
    private func goAddPage() {
        let vc = AddViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    private func goSettingsPage() {
        let vc = SettingsViewController()
        vc.delegate = self
        vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(vc, animated: true)
    }
}

//MARK: - Layout

extension ViewController {
    
    func style() {
        configureBarButton()
        view.backgroundColor = Colors.backgroundColor
        
        routineCV.delegate = self
        routineCV.dataSource = self
        routineCV.layer.cornerRadius = 8
        routineCV.backgroundColor = Colors.viewColor
        routineCV.register(RoutineCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        daySegmentedControl.replaceSegments(segments: brain.days[UserDefault.selectedDayType.getInt()])
        daySegmentedControl.selectedSegmentIndex = 0
        daySegmentedControl.tintColor = .black
        daySegmentedControl.addTarget(self, action: #selector(self.daySegmentedControlChanged), for: .valueChanged)
    }
    
    func layout() {
        let stack = UIStackView(arrangedSubviews: [routineCV, daySegmentedControl])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        
        view.addSubview(stack)
        
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                     bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                     paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        daySegmentedControl.setHeight(50)
    }
    
    private func updatePlaceholderViewVisibility(){
        view.addSubview(placeholderView)
        placeholderView.centerX(inView: routineCV)
        placeholderView.centerY(inView: routineCV)
        placeholderView.isHidden = tempArray.count != 0
    }
}

//MARK: - UICollectionViewDelegate/DataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RoutineCell
        cell.routine = brain.routineArray[tempArray[indexPath.row]]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
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

extension ViewController {
    private func addGestureRecognizer(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeLeft))
        swipeLeft.direction = .left
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeRight))
        swipeRight.direction = .right
        
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc private func respondToSwipeLeft(gesture: UISwipeGestureRecognizer) {
        selectedSegmentIndex = (selectedSegmentIndex + 1 > 6) ? 0 : selectedSegmentIndex + 1
        daySegmentedControl.selectedSegmentIndex = selectedSegmentIndex
        findWhichRoutinesShouldShow()
    }
        
    @objc private func respondToSwipeRight(gesture: UISwipeGestureRecognizer) {
        selectedSegmentIndex = (selectedSegmentIndex - 1 < 0) ? 6 : selectedSegmentIndex - 1
        daySegmentedControl.selectedSegmentIndex = selectedSegmentIndex
        findWhichRoutinesShouldShow()
    }
}

//MARK: - UpdateDelegate

extension ViewController: UpdateDelegate {
    func updateCV() {
        brain.loadRoutineArray()
        updateSegmentedControlByDay()
        findWhichRoutinesShouldShow()
    }
}
