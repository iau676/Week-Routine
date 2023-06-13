//
//  RoutineCell.swift
//  Week Routine
//
//  Created by ibrahim uysal on 23.04.2023.
//

import UIKit

protocol RoutineCellDelegate: AnyObject {
    func goLog(routine: Routine)
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
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = Images.ice
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let routineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 17)
        label.textColor = .label
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 13)
        label.textColor = .darkGray
        return label
    }()
    
    private let historyButton: UIButton = {
        let button = UIButton()
        button.setDimensions(width: 32, height: 32)
        button.setImageWithRenderingMode(image: Images.history, width: 24, height: 24, color: .label)
        return button
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
        
        historyButton.addTarget(self, action: #selector(historyPressed), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editPressed), for: .touchUpInside)
        
        addSubview(borderView)
        borderView.anchor(top: topAnchor, left: leftAnchor,
                          bottom: bottomAnchor, right: rightAnchor,
                          paddingTop: 0, paddingLeft: 16,
                          paddingBottom: 0, paddingRight: 16)
        
        let buttonStack = UIStackView(arrangedSubviews: [historyButton, editButton])
        buttonStack.distribution = .fillEqually
        buttonStack.axis = .horizontal
        buttonStack.spacing = 16
        
        addSubview(buttonStack)
        buttonStack.centerY(inView: borderView)
        buttonStack.anchor(right: borderView.rightAnchor, paddingRight: 16)
        
        let labelStack = UIStackView(arrangedSubviews: [dateLabel, routineLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 0

        addSubview(labelStack)
        labelStack.centerY(inView: borderView)
        labelStack.anchor(left: borderView.leftAnchor, right: buttonStack.leftAnchor,
                     paddingLeft: 16, paddingRight: 16)
        
        addSubview(imageView)
        imageView.setDimensions(width: 50, height: 50)
        imageView.centerX(inView: self)
        imageView.centerY(inView: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc private func historyPressed() {
        guard let routine = routine else { return }
        delegate?.goLog(routine: routine)
    }
    
    @objc private func editPressed() {
        guard let routine = routine else { return }
        delegate?.goEdit(routine: routine)
    }
    
    //MARK: - Helpers
    
    private func configure() {
        guard let routine = routine else { return }
                
        let day = brain.getDayName(routine.day)
        let hour = routine.hour < 10 ? "0\(routine.hour)" : "\(routine.hour)"
        let minute = routine.minute < 10 ? "0\(routine.minute)" : "\(routine.minute)"
        let color = brain.getColor(routine.color ?? ColorName.defaultt)
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "\(routine.title ?? "")")

        routineLabel.attributedText = attributeString
        
        var dateText = "\(hour):\(minute)・\(day)"
        let  timerText = routine.timerSeconds > 0 ? "・Timer: \(brain.getTimerString(for: Int(routine.timerSeconds)))" : ""
        dateText.append(timerText)
        dateLabel.text = dateText
        
        imageView.isHidden = true
        borderView.layer.borderColor = color.cgColor
        borderView.backgroundColor = .clear
        
        if let lastLogDate = routine.logArray.first?.date {
            if brain.getDayInt() == selectedSegmentIndex && Calendar.current.isDateInToday(lastLogDate) {
                borderView.backgroundColor = color.withAlphaComponent(0.3)
            }
        }
        
        if routine.isFrozen {
            imageView.isHidden = false
            borderView.backgroundColor = Colors.iceColor.withAlphaComponent(0.5)
            borderView.layer.borderColor = Colors.iceColor.cgColor
        }
    }
}
