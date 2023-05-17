//
//  TableViewPlaceholderView.swift
//  Week Routine
//
//  Created by ibrahim uysal on 2.12.2022.
//

import UIKit

final class PlaceholderView: UIView {
    
    private let text: String
    
    private let imageView: UIImageView = {
        let image = Images.routine
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Colors.placeholderColor
        return imageView
    }()
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.AvenirNextMedium, size: 17)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = Colors.placeholderColor
        return label
    }()
    
    init(text: String) {
        self.text = text
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        titleLabel.text = text
        
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stack.axis = .vertical
        stack.spacing = 8
        
        addSubview(stack)
        stack.setDimensions(width: 120, height: 120)
        stack.centerX(inView: self)
        stack.centerY(inView: self)
    }
}
