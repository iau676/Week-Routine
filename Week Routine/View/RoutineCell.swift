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
    
    var routine: Routine? { didSet { configure() } }
    weak var delegate: RoutineCellDelegate?
    
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
    
    private let borderView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2
        return view
    }()
    
    private lazy var historyButton = UIButton()
    private lazy var editButton = UIButton()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        historyButton.setImageWithRenderingMode(image: Images.history, width: 24, height: 24, color: .label)
        editButton.setImageWithRenderingMode(image: Images.dots, width: 24, height: 24, color: .label)
        
        historyButton.addTarget(self, action: #selector(historyPressed), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editPressed), for: .touchUpInside)
        
        addSubview(borderView)
        borderView.anchor(top: topAnchor, left: leftAnchor,
                          bottom: bottomAnchor, right: rightAnchor,
                          paddingTop: 8, paddingLeft: 8,
                          paddingBottom: 8, paddingRight: 8)
        
        historyButton.setDimensions(width: 24, height: 24)
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
        
        
//        let todayDate = brain.getTodayDate()
//        if routine.isDone == true && routine.doneDate == todayDate {
//            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
//            self.alpha = 0.5
//        } else {
//            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle , range: NSRange(location: 0, length: attributeString.length))
//            self.alpha = 1
//        }

        routineLabel.attributedText = attributeString
        dateLabel.text = "\(hour):\(minute) ・ \(day)"
        
        borderView.layer.borderColor = color.cgColor
    }
}
