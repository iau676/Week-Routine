//
//  RoutineFooter.swift
//  Week Routine
//
//  Created by ibrahim uysal on 15.06.2023.
//

import UIKit

private let reIdentifier = "FilterCell"

protocol RoutineFooterDelegate: AnyObject {
    func goAdd()
}

final class RoutineFooter: UICollectionReusableView {
    
    //MARK: - Properties
    
    weak var delegate: RoutineFooterDelegate?
    private let button = UIButton()
        
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        button.setImageWithRenderingMode(image: Images.plus, width: 24, height: 24, color: .lightGray)
        button.addTarget(self, action: #selector(goAdd), for: .touchUpInside)
        
        button.backgroundColor = Colors.viewColor
        addSubview(button)
        button.fillSuperview()
    }
    
    override func layoutSubviews() {}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc private func goAdd() {
        delegate?.goAdd()
    }
}
