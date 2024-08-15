//
//  DeleteView.swift
//  Week Routine
//
//  Created by ibrahim uysal on 15.08.2024.
//

import UIKit
import SwiftUI

protocol DeleteViewDelegate {
    func cancel()
    func delete()
}

class DeleteView: UIView {
    
    private var answer: Int = 0
    var delegate: DeleteViewDelegate?
    
    private let centerView: UIView = {
       let view = UIView()
        view.backgroundColor = Colors.viewColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.labelColor
        label.text = "Routine will be deleted"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.labelColor
        label.text = "This action cannot be undone\nPlease answer the question to confirm"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.backgroundColor = .lightGray
        tf.layer.cornerRadius = 4
        tf.layer.borderWidth = 0.75
        tf.layer.borderColor = Colors.labelColor?.cgColor
        tf.setLeftPaddingPoints(10)
        return tf
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(Colors.labelColor, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = Colors.backgroundColor?.withAlphaComponent(0.9)
        
        configureTextFieldPlaceholder()
        
        addSubview(centerView)
        centerView.centerY(inView: self)
        centerView.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 32, paddingRight: 32)
        centerView.setHeight(200)
        
        let labelStack = UIStackView(arrangedSubviews: [titleLabel, messageLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 4
        labelStack.alignment = .center
        
        centerView.addSubview(labelStack)
        labelStack.anchor(top: centerView.topAnchor, left: centerView.leftAnchor, right: centerView.rightAnchor, paddingTop: 16, paddingLeft: 8, paddingRight: 8)
        labelStack.centerX(inView: centerView)
        
        centerView.addSubview(textField)
        textField.anchor(top: messageLabel.bottomAnchor, left: centerView.leftAnchor, right: centerView.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingRight: 32)
        textField.setHeight(40)
        
        let buttonStack = UIStackView(arrangedSubviews: [cancelButton, deleteButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 1
        buttonStack.distribution = .fillEqually
        
        centerView.addSubview(buttonStack)
        cancelButton.setHeight(50)
        deleteButton.setHeight(50)
        buttonStack.anchor(left: centerView.leftAnchor, bottom: centerView.bottomAnchor, right: centerView.rightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func cancelButtonPressed() {
        delegate?.cancel()
    }
    
    @objc private func deleteButtonPressed() {
        guard let text = textField.text else { return }
        
        if answer == Int(text) {
            delegate?.delete()
        } else {
            textField.flash()
        }
    }
    
    private func configureTextFieldPlaceholder() {
        let leftNumber = Int.random(in: 100..<199)
        let rightNumber = 7
        answer = leftNumber + rightNumber
        
        textField.placeholder = " \(leftNumber) + \(rightNumber) = ?"
    }
}
