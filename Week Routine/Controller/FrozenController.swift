//
//  FrozenController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 9.08.2024.
//

import UIKit

private let reuseIdentifier = "RoutineCell"

protocol FrozenControllerDelegate: AnyObject {
    func updateCV()
}

final class FrozenController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: FrozenControllerDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.layer.cornerRadius = 8
        cv.backgroundColor = Colors.viewColor
        cv.register(RoutineCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    
    private lazy var tempArray = [Int]() { didSet { collectionView.reloadData() } }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        findWhichRoutinesShouldShow()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    private func findWhichRoutinesShouldShow() {
        tempArray.removeAll()
        tempArray = brain.findFrozenRoutines()
    }
}

//MARK: - UICollectionViewDataSource

extension FrozenController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RoutineCell
        cell.routine = brain.routineArray[tempArray[indexPath.row]]
        cell.delegate = self
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FrozenController: UICollectionViewDelegateFlowLayout {
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

//MARK: - AddControllerDelegate

extension FrozenController: AddControllerDelegate {
    func updateCV() {
        brain.loadRoutineArray()
        findWhichRoutinesShouldShow()
        delegate?.updateCV()
    }
}

//MARK: - RoutineCellDelegate

extension FrozenController: RoutineCellDelegate {
    func goEdit(routine: Routine) {
        let controller = AddEditController()
        controller.delegate = self
        controller.routine = routine
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .formSheet
        self.present(nav, animated: true)
    }
}
