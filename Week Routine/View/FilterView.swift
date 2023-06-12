//
//  FilterView.swift
//  Week Routine
//
//  Created by ibrahim uysal on 10.06.2023.
//

import UIKit

private let reIdentifier = "FilterCell"

protocol FilterViewDelegate: AnyObject {
    func filterView(_ view: FilterView, didSelect index: Int)
}

final class FilterView: UICollectionReusableView {
    
    //MARK: - Properties
    
    weak var delegate: FilterViewDelegate?
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
        
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Colors.viewColor
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: reIdentifier)
        
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        let grayView = UIView()
        grayView.backgroundColor = .lightGray
        addSubview(grayView)
        grayView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 0.75)
    }
    
    override func layoutSubviews() {}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func updateSelected(for index: Int) {
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: [], animated: true)
        collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
}

//MARK: - UICollectionViewDataSource

extension FilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FilterOptions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reIdentifier, for: indexPath) as! FilterCell
        let option = FilterOptions(rawValue: indexPath.row)
        cell.option = option
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/3, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: - UICollectionViewDelegate

extension FilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.filterView(self, didSelect: indexPath.row)
        var index = indexPath.row
        index = (index > 7) ? 1 : (index < 1) ? 7 : index
        updateSelected(for: index)
    }
}
