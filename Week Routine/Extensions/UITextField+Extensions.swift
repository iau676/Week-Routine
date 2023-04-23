//
//  UITextField+Extensions.swift
//  Week Routine
//
//  Created by ibrahim uysal on 6.10.2022.
//

import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func flash() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = Colors.flashColor
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3){
            UIView.animate(withDuration: 0.1, animations: {
                self.backgroundColor = Colors.viewColor
            })
        }
    }
}
