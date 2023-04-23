//
//  UIButton+Extensions.swift
//  Week Routine
//
//  Created by ibrahim uysal on 11.10.2022.
//

import UIKit

extension UIButton {
    func moveImageRightTextCenter(imagePadding: CGFloat = 32.0){
        guard let imageViewWidth = self.imageView?.frame.width else{return}
        guard let titleLabelWidth = self.titleLabel?.intrinsicContentSize.width else{return}
        self.contentHorizontalAlignment = .left
        imageEdgeInsets = UIEdgeInsets(top: 0.0, left: bounds.width-32.0, bottom: 0.0, right: 0.0)
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: (bounds.width - titleLabelWidth) / 2 - imageViewWidth, bottom: 0.0, right: 0.0)
    }
    
    func updateIcon(_ imageName: String, _ buttonImageSize: Int) {
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate).withTintColor(UIColor.white)
        self.setImage(UIGraphicsImageRenderer(size: CGSize(width: buttonImageSize, height: buttonImageSize)).image { _ in
            image?.draw(in: CGRect(x: 0, y: 0, width: buttonImageSize, height: buttonImageSize)) }, for: .normal)
    }
    
    func setImageWithRenderingMode(image: UIImage?, width: CGFloat, height: CGFloat, color: UIColor){
        let image = image?.withRenderingMode(.alwaysTemplate).imageResized(to: CGSize(width: width, height: height)).withTintColor(color)
        self.setImage(image, for: .normal)
    }
}
