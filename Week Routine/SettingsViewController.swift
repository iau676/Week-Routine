//
//  SettingsNewViewController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 6.10.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let stackView = UIStackView()
    
    let dayFormatLabel = UILabel()
    let dayFormatSegmentedControl = UISegmentedControl()
    let dayFormatItems = ["Sun", "7", "VII"]
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        addGestureRecognizer()
    }
    
    //MARK: - Helpers
    
    func addGestureRecognizer(){
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    //MARK: - Selectors
    
    @objc func respondToSwipeGesture(gesture: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func dayFormatSegmentedControlChanged(segment: UISegmentedControl) -> Void {
        switch segment.selectedSegmentIndex {
        case 1:
            print("1")
        default:
            print("d")
        }
    }
}

//MARK: - Layout

extension SettingsViewController {
    
    func style() {
        view.backgroundColor = Colors.backgroundColor
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        dayFormatLabel.translatesAutoresizingMaskIntoConstraints = false
        dayFormatLabel.textColor = Colors.labelColor
        dayFormatLabel.text = "Date Format"
        dayFormatLabel.numberOfLines = 1
        
        dayFormatSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        dayFormatSegmentedControl.replaceSegments(segments: dayFormatItems)
        dayFormatSegmentedControl.selectedSegmentIndex = 0
        dayFormatSegmentedControl.tintColor = .black
        dayFormatSegmentedControl.addTarget(self, action: #selector(self.dayFormatSegmentedControlChanged), for: UIControl.Event.valueChanged)
    }
    
    func layout() {
        
        stackView.addArrangedSubview(dayFormatLabel)
        stackView.addArrangedSubview(dayFormatSegmentedControl)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
