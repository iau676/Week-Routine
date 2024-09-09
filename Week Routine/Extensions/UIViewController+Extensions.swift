//
//  UIViewController+Extensions.swift
//  Week Routine
//
//  Created by ibrahim uysal on 23.04.2023.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func size(forText text: String?, minusWidth: CGFloat = 32) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.lineBreakMode = .byWordWrapping
        label.setWidth(self.view.frame.width-minusWidth)
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    func showDeleteAlert(title: String, message: String, completion: @escaping(Bool)-> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionDelete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            completion(true)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(actionDelete)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, errorMessage: String, completion: @escaping(Bool)-> Void) {
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: false, completion: nil)
            completion(true)
        }
        alert.addAction(actionOK)
        present(alert, animated: true)
    }
    
    func showAlertWithTimer(title: String, time: TimeInterval = 0.5) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let when = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: when){
          alert.dismiss(animated: true, completion: nil)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showActionSheet(title: String, message: String = "",  actionTitle: String, style: UIAlertAction.Style = .default, completion: @escaping()-> Void) {
        
        var alertStyle: UIAlertController.Style = UIAlertController.Style.actionSheet
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            alertStyle = UIAlertController.Style.alert
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        let actionOK = UIAlertAction(title: actionTitle, style: style) { (action) in
            alert.dismiss(animated: false, completion: nil)
            completion()
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(actionOK)
        alert.addAction(actionCancel)
        present(alert, animated: true)
    }
}

