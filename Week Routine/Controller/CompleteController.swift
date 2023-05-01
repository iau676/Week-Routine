//
//  CompleteController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 30.04.2023.
//

import UIKit

final class CompleteController: UIViewController {
    
    //MARK: - Properties
    
    private let routine: Routine
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
    }
    
    //MARK: - Selectors
    
    @objc func saveButtonPressed() {
        print("DEBUG::saveButtonPressed")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissView() {
        print("DEBUG::dismissView")
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    private func style() {
        configureBarButton()
        view.backgroundColor = .systemGroupedBackground
        
        textView.becomeFirstResponder()
        textView.backgroundColor = .secondarySystemBackground
    }
    
    private func layout() {
        view.addSubview(textView)
        textView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
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
}
