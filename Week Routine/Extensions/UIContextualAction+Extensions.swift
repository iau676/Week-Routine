//
//  UIContextualAction+Extensions.swift
//  Week Routine
//
//  Created by ibrahim uysal on 2.12.2022.
//

import UIKit

extension UIContextualAction {
    func setImage(image: UIImage?, width: CGFloat, height: CGFloat){
        self.image = UIGraphicsImageRenderer(size: CGSize(width: width, height: height)).image { _ in
            image?.draw(in: CGRect(x: 0, y: 0, width: width, height: height)) }
    }
    
    func setBackgroundColor(_ uicolor: UIColor?){
        self.backgroundColor = uicolor
    }
}
