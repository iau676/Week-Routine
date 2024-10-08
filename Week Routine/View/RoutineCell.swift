//
//  RoutineCell.swift
//  Week Routine
//
//  Created by ibrahim uysal on 23.04.2023.
//

import UIKit

protocol RoutineCellDelegate: AnyObject {
    func goEdit(routine: Routine)
}

final class RoutineCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var selectedSegmentIndex: Int?
    var routine: Routine? { didSet { configure() } }
    weak var delegate: RoutineCellDelegate?
    
    private let borderView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2
        return view
    }()
    
    private let snowflakeImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = Images.snowflake?.withTintColor(Colors.iceColor)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let notificationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = Images.notificationClosed?.withTintColor(Colors.dateLabelTextColor ?? .darkGray)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let routineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 17)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 13)
        label.textColor = Colors.dateLabelTextColor
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setDimensions(width: 32, height: 32)
        button.setImageWithRenderingMode(image: Images.dots, width: 24, height: 24, color: .label)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        editButton.addTarget(self, action: #selector(editPressed), for: .touchUpInside)
        
        addSubview(borderView)
        borderView.anchor(top: topAnchor, left: leftAnchor,
                          bottom: bottomAnchor, right: rightAnchor,
                          paddingTop: 0, paddingLeft: 16,
                          paddingBottom: 0, paddingRight: 16)
        
        addSubview(snowflakeImageView)
        snowflakeImageView.setDimensions(width: 40, height: 40)
        snowflakeImageView.centerX(inView: self)
        snowflakeImageView.centerY(inView: self)
        
        addSubview(editButton)
        editButton.centerY(inView: borderView)
        editButton.anchor(right: borderView.rightAnchor, paddingRight: 16)
        
        notificationImageView.setDimensions(width: 16, height: 16)
        let infoStack = UIStackView(arrangedSubviews: [notificationImageView, dateLabel])
        infoStack.axis = .horizontal
        infoStack.spacing = 0
        
        let labelStack = UIStackView(arrangedSubviews: [infoStack, routineLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 0

        addSubview(labelStack)
        labelStack.centerY(inView: borderView)
        labelStack.anchor(left: borderView.leftAnchor, right: editButton.leftAnchor,
                          paddingLeft: 16, paddingRight: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc private func editPressed() {
        guard let routine = routine else { return }
        editButton.bounce()
        delegate?.goEdit(routine: routine)
    }
    
    //MARK: - Helpers
    
    private func configure() {
        guard let routine = routine else { return }
                
        let day = getDayName(routine.day)
        let hour = routine.hour < 10 ? "0\(routine.hour)" : "\(routine.hour)"
        let minute = routine.minute < 10 ? "0\(routine.minute)" : "\(routine.minute)"
        let color = getColor(routine.color ?? ColorName.defaultt)
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "\(routine.title ?? "")")

        routineLabel.attributedText = attributeString
        dateLabel.text = routine.isNotify ? "\(hour):\(minute)・\(day)" : "・\(hour):\(minute)・\(day)"
        
        snowflakeImageView.isHidden = true
        borderView.layer.borderColor = color.cgColor
        borderView.backgroundColor = .clear
        
        if brain.checkCompletedToday(routine: routine, selectedSegmentIndex: selectedSegmentIndex ?? 0) {
            borderView.backgroundColor = color.withAlphaComponent(0.5)
        }
        
        if routine.isFrozen {
            snowflakeImageView.isHidden = false
            borderView.backgroundColor = Colors.iceColor.withAlphaComponent(0.6)
            borderView.layer.borderColor = Colors.iceColor.cgColor
        }
        
        notificationImageView.isHidden = routine.isNotify
    }
}
