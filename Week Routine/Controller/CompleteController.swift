//
//  CompleteController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 30.04.2023.
//

import UIKit

protocol CompleteControllerDelegate : AnyObject {
    func updateTableView()
}

final class CompleteController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: CompleteControllerDelegate?
    private let routine: Routine
    
    private let timerLabel = UILabel()
    private let textView = InputTextView()
    
    //MARK: - Lifecycle
    
    init(routine: Routine) {
        self.routine = routine
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        configureTimerLabelVisibility()
    }
    
    //MARK: - Selectors
    
    @objc private func saveButtonPressed() {
        guard let content = textView.text else { return }
        brain.addLog(routine: routine, content: content)
        delegate?.updateTableView()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    private func style() {
        configureBarButton()
        view.backgroundColor = .systemGray5
        
        timerLabel.text = "Timer Completed!"
        timerLabel.textColor = Colors.labelColor
        timerLabel.textAlignment = .center
        
        textView.becomeFirstResponder()
        textView.backgroundColor = Colors.viewColor
    }
    
    private func layout() {
        let stack = UIStackView(arrangedSubviews: [timerLabel, textView])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 16,
                     paddingLeft: 16, paddingRight: 16)
    }
    
    private func configureBarButton() {
        title = routine.title
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(saveButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = Colors.labelColor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(dismissView))
        navigationItem.leftBarButtonItem?.tintColor = Colors.labelColor
    }
    
    private func configureTimerLabelVisibility() {
        if UDM.isTimerCompleted.getBool() {
            timerLabel.isHidden = true
        } else {
            UDM.isTimerCompleted.set(true)
            timerLabel.isHidden = false
        }
    }
}
