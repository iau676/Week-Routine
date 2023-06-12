//
//  LogCell.swift
//  Week Routine
//
//  Created by ibrahim uysal on 30.04.2023.
//

import UIKit

final class LogCell: UITableViewCell {
    
    //MARK: - Properties
    
    var log: Log? { didSet { configure() } }
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 13)
        label.textColor = .darkGray
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 17)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 13)
        label.textColor = .darkGray
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Colors.viewColor
        
        let stack = UIStackView(arrangedSubviews: [dateLabel, contentLabel])
        stack.axis = .vertical
        stack.spacing = 1
        
        addSubview(stack)
        stack.centerY(inView: self)
        stack.anchor(left: leftAnchor, right: rightAnchor,
                     paddingLeft: 16, paddingRight: 16)
        
        addSubview(timerLabel)
        timerLabel.centerY(inView: dateLabel)
        timerLabel.anchor(right: rightAnchor, paddingRight: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configure() {
        guard let log = log else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm・E, d MMM y"
        
        dateLabel.text = "\(dateFormatter.string(from: log.date ?? Date()))"
        contentLabel.text = log.content
        if log.timerSeconds > 0 { timerLabel.text = "Timer: \(brain.getTimerString(for: Int(log.timerSeconds)))" }
    }
}
