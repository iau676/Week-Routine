//
//  ViewController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 5.10.2022.
//

import UIKit

private let reuseIdentifier = "RoutineCell"
private let headerIdentifier = "FilterView"
private let footerIdentifier = "RoutineFooter"

final class RoutineController: UICollectionViewController {

    private let placeholderView = PlaceholderView(text: "No Routine")
    private var tempArray = [Int]() { didSet { collectionView.reloadData() } }
    private var currrentIndex: Int = 0
    
    private lazy var celebrateAnimationView: CelebrationAnimationView = {
        let v = CelebrationAnimationView(fileName: AnimationName.blueBalloon)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        return v
    }()
        
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
        NotificationManager.shared.askNotificationPermission()
        currrentIndex = brain.getDayInt()+1
        findWhichRoutinesShouldShow()
    }
    
    //MARK: - Selectors
    
    @objc private func configureBarButton() {
        title = "Week Routine"
        
        let leftBarIV = UIImageView()
        leftBarIV.setDimensions(width: 20, height: 20)
        leftBarIV.image = Images.notification?.withTintColor(Colors.labelColor ?? .black, renderingMode: .alwaysOriginal)
        
        let tapLeft = UITapGestureRecognizer(target: self, action: #selector(leftBarButtonPressed))
        leftBarIV.addGestureRecognizer(tapLeft)

        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
           DispatchQueue.main.async {
               self.navigationItem.leftBarButtonItem = settings.authorizationStatus != .authorized && UDM.version12.getBool() ?  UIBarButtonItem(customView: leftBarIV) : UIBarButtonItem()
           }
        }
        
        let rightBarIV = UIImageView()
        rightBarIV.setDimensions(width: 24, height: 24)
        rightBarIV.image = Images.snowflake?.withTintColor(Colors.labelColor ?? .black, renderingMode: .alwaysOriginal)
        
        let tapRight = UITapGestureRecognizer(target: self, action: #selector(rightBarButtonPressed))
        rightBarIV.addGestureRecognizer(tapRight)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarIV)
    }
    
    @objc private func leftBarButtonPressed() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func rightBarButtonPressed() {
        let controller = FrozenController()
        self.present(controller, animated: true)
    }

    //MARK: - Helpers
    
    private func style() {
        view.backgroundColor = Colors.backgroundColor

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.cornerRadius = 8
        collectionView.backgroundColor = Colors.viewColor
        collectionView.register(RoutineCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(FilterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
        collectionView.register(RoutineFooter.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: footerIdentifier)
        
        view.addSubview(celebrateAnimationView)
        celebrateAnimationView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                      right: view.rightAnchor)
        celebrateAnimationView.setHeight(view.frame.width)
    }
    
    private func updatePlaceholderViewVisibility(){
        view.addSubview(placeholderView)
        placeholderView.centerX(inView: collectionView)
        placeholderView.centerY(inView: collectionView)
        placeholderView.isHidden = tempArray.count != 0
    }
    
    private func findWhichRoutinesShouldShow() {
        currrentIndex = (currrentIndex > 7) ? 1 : (currrentIndex < 1) ? 7 : currrentIndex
        tempArray.removeAll()
        tempArray = brain.findRoutines(for: currrentIndex-1)
        updatePlaceholderViewVisibility()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.configureBarButton),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.bounces = collectionView.contentOffset.y > 0 //disable bounce from top
    }
}

//MARK: - UICollectionViewDataSource

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
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! FilterView
            header.delegate = self
            header.updateSelected(for: currrentIndex)
            return header
        default:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath) as! RoutineFooter
            footer.delegate = self
            return footer
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currrentIndex == brain.getDayInt()+1 {
            let routine = brain.routineArray[tempArray[indexPath.row]]
            
            if routine.isFrozen {
                self.showAlertWithTimer(title: "Frozen")
            } else if routine.isDone {
                self.showAlertWithTimer(title: "Completed")
            } else if brain.checkTimePassed(routine: routine) {
                let remind = brain.getRemindHour(routine: routine)
                self.showAlertWithTimer(title: "Not yet\n\nRemind: \(remind)")
            } else {
                self.showActionSheet(title: "\(routine.title ?? "")", actionTitle: "Complete") {
                    brain.addLog(routine: routine)
                    self.collectionView.reloadData()
                    self.celebrateAnimationView.selectAnimation(withColorName: routine.color)
                    self.celebrateAnimationView.isHidden = false
                    self.celebrateAnimationView.play { finished in
                        self.celebrateAnimationView.isHidden = finished
                    }
                }
            }
        } else {
            self.showAlertWithTimer(title: "Not Today")
        }
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.bounce(scaleX: 0.95)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension RoutineController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let routine = brain.routineArray[tempArray[indexPath.row]]
        let textHeight = size(forText: routine.title, minusWidth: 32+32+50+50).height
        return CGSize(width: view.bounds.width, height: textHeight+66)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
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

//MARK: - AddControllerDelegate

extension RoutineController: AddControllerDelegate {
    func updateCV() {
        brain.loadRoutineArray()
        findWhichRoutinesShouldShow()
    }
}

//MARK: - RoutineCellDelegate

extension RoutineController: RoutineCellDelegate {
    func goEdit(routine: Routine) {
        let controller = AddEditController(currrentIndex: currrentIndex)
        controller.delegate = self
        controller.routine = routine
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .formSheet
        self.present(nav, animated: true)
    }
}

//MARK: - FilterViewDelegate

extension RoutineController: FilterViewDelegate {
    func filterView(_ view: FilterView, didSelect index: Int) {
        currrentIndex = index
        findWhichRoutinesShouldShow()
    }
}

//MARK: - RoutineFooterDelegate

extension RoutineController: RoutineFooterDelegate {
    func goAdd() {
        let controller = AddEditController(currrentIndex: currrentIndex)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .formSheet
        self.present(nav, animated: true)
    }
}
