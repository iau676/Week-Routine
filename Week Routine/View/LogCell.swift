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
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: topAnchor, left: leftAnchor,
                         paddingTop: 4, paddingLeft: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configure() {
//        guard let log = log else { return }
    }
}
