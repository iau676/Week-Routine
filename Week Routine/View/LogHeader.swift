//
//  LogHeader.swift
//  Week Routine
//
//  Created by ibrahim uysal on 13.06.2023.
//

import UIKit

protocol LogHeaderDelegate: AnyObject {
    func routineChanged()
}

final class LogHeader: UIView {
    
    //MARK: - Properties
    
    weak var delegate: LogHeaderDelegate?
    
    var routine: Routine? {
        didSet { configure() }
    }
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = Colors.labelColor
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Helpers
    
    private func configure() {
        titleLabel.text = "Total: \(routine?.logArray.count ?? 0)"
    }
    
    private func configureUI() {
        backgroundColor = Colors.viewColor
        
        addSubview(titleLabel)
        titleLabel.centerX(inView: self)
        titleLabel.centerY(inView: self)
        
        let topLineView = UIView()
        topLineView.backgroundColor = .lightGray
        addSubview(topLineView)
        topLineView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = .lightGray
        addSubview(bottomLineView)
        bottomLineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 0.5)
    }
}
