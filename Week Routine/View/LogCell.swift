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
        
        addSubview(dateLabel)
        dateLabel.centerY(inView: self)
        dateLabel.anchor(left: leftAnchor, right: rightAnchor,
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
        guard let date = log.date else { return }
        dateLabel.text = "\(date.getFormattedDate(format: DateFormat.LogCell))"
    }
}
