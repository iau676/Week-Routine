//
//  RoutineCell.swift
//  Week Routine
//
//  Created by ibrahim uysal on 23.04.2023.
//

import UIKit

final class RoutineCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var routine: Routine? {
        didSet {
            configure()
        }
    }

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
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        addSubview(borderView)
        borderView.anchor(top: topAnchor, left: leftAnchor,
                          bottom: bottomAnchor, right: rightAnchor,
                          paddingTop: 8, paddingLeft: 8,
                          paddingBottom: 8, paddingRight: 8)
        
        let stack = UIStackView(arrangedSubviews: [dateLabel, routineLabel])
        stack.axis = .vertical
        stack.spacing = 0

        addSubview(stack)
        stack.centerY(inView: borderView)
        stack.anchor(left: borderView.leftAnchor, paddingLeft: 16)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
