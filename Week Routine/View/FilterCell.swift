//
//  FilterCell.swift
//  Week Routine
//
//  Created by ibrahim uysal on 10.06.2023.
//

import UIKit

enum FilterOptions: Int, CaseIterable {
    case Sun0
    case Mon
    case Tue
    case Wed
    case Thu
    case Fri
    case Sat
    case Sun
    case Mon0
    
    var description: String {
        switch self {
        case .Sun0: return "Sunday"
        case .Mon: return "Monday"
        case .Tue: return "Tuesday"
        case .Wed: return "Wednesday"
        case .Thu: return "Thursday"
        case .Fri: return "Friday"
        case .Sat: return "Saturday"
        case .Sun: return "Sunday"
        case .Mon0: return "Monday"
        }
    }
}

final class FilterCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var option: FilterOptions! {
        didSet { titleLabel.text = option.description }
    }
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let underlineView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? .systemBlue : .lightGray
            underlineView.isHidden = !isSelected
        }
    }
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.viewColor
        
        addSubview(titleLabel)
        titleLabel.centerX(inView: self)
        titleLabel.centerY(inView: self)
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor,
                             right: rightAnchor, height: 2)
        underlineView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
