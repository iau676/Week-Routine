//
//  ViewController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 5.10.2022.
//

import UIKit

private let reuseIdentifier = "RoutineCell"
private let headerIdentifier = "FilterView"

final class RoutineController: UICollectionViewController {

    private let placeholderView = PlaceholderView(text: "No Routine")
    private var tempArray = [Int]() { didSet { collectionView.reloadData() } }
    private var currrentIndex = 0
        
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        updateCV()
        addObserver()
        addGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        brain.askNotificationPermission()
        currrentIndex = brain.getDayInt()+1
        findWhichRoutinesShouldShow()
    }
    
    //MARK: - Selectors
    
    @objc private func addButtonPressed() {
        let controller = AddController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .formSheet
        self.present(nav, animated: true)
    }
    
    @objc private func leftBarButtonPressed() {
        print("DEBUG::leftBarButtonPressed")
    }
    
    @objc private func checkTimer() {
        let routineUUID = UDM.routineUUID.getString()
        brain.findRoutine(uuid: routineUUID) { routine in
            guard let currentNotificationDate = UDM.currentNotificationDate.getDateValue() else { return }
            let dateComponents = Calendar.current.dateComponents([.second], from: currentNotificationDate, to: Date())
            guard let passedSeconds = dateComponents.second else { return }
            let lastTimerCounter = UDM.lastTimerCounter.getInt()
            let timerSeconds = Int(routine.timerSeconds)
            
            //timer working
            if timerSeconds - lastTimerCounter - passedSeconds > 0 {
                let controller = TimerController(routine: routine)
                controller.timerCounter = CGFloat(lastTimerCounter + passedSeconds)
                controller.modalPresentationStyle = .overCurrentContext
                self.present(controller, animated: true)
            } else {
                if !UDM.isTimerCompleted.getBool() {
                    UDM.isTimerCompleted.set(true)
                    let controller = CompleteController(routine: routine)
                    controller.delegate = self
                    let nav = UINavigationController(rootViewController: controller)
                    nav.modalPresentationStyle = .formSheet
                    self.present(nav, animated: true)
                }
            }
        }
    }

    //MARK: - Helpers
    
    private func style() {
        configureBarButton()
        view.backgroundColor = Colors.backgroundColor

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.cornerRadius = 8
        collectionView.backgroundColor = Colors.viewColor
        collectionView.register(RoutineCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(FilterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
    }
    
    private func updatePlaceholderViewVisibility(){
        view.addSubview(placeholderView)
        placeholderView.centerX(inView: collectionView)
        placeholderView.centerY(inView: collectionView)
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
        let tapLeft = UITapGestureRecognizer(target: self, action: #selector(leftBarButtonPressed))
        leftBarIV.addGestureRecognizer(tapLeft)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarIV)
    }
    
    private func findWhichRoutinesShouldShow() {
        currrentIndex = (currrentIndex > 7) ? 1 : (currrentIndex < 1) ? 7 : currrentIndex
        tempArray.removeAll()
        tempArray = brain.findRoutines(for: currrentIndex-1)
        updatePlaceholderViewVisibility()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkTimer),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
    }
}

//MARK: - UITableViewDataSource

extension RoutineController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RoutineCell
        cell.selectedSegmentIndex = currrentIndex-1
        cell.routine = brain.routineArray[tempArray[indexPath.row]]
        cell.delegate = self
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension RoutineController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! FilterView
        header.delegate = self
        header.updateSelected(for: currrentIndex)
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currrentIndex == brain.getDayInt()+1 {
            let routine = brain.routineArray[tempArray[indexPath.row]]
            
            if routine.timerSeconds > 0 {
                let controller = TimerController(routine: routine)
                controller.modalPresentationStyle = .overCurrentContext
                self.present(controller, animated: true)
            } else {
                let controller = CompleteController(routine: routine)
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .formSheet
                self.present(nav, animated: true)
            }
        } else {
            self.showAlertWithTimer(title: "Not Today")
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension RoutineController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
}

//MARK: - Swipe Gesture

extension RoutineController {
    private func addGestureRecognizer(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc private func respondToGesture(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left: currrentIndex = (currrentIndex + 1 > 7) ? 1 : currrentIndex + 1
        case .right: currrentIndex = (currrentIndex - 1 < 1) ? 7 : currrentIndex - 1
        default: break }
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
        collectionView.reloadData()
    }
}

//MARK: - FilterViewDelegate

extension RoutineController: FilterViewDelegate {
    func filterView(_ view: FilterView, didSelect index: Int) {
        currrentIndex = index
        findWhichRoutinesShouldShow()
    }
}
