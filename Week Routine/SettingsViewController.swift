//
//  SettingsNewViewController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 6.10.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    let dayFormatStackView = UIStackView()
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
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        
        dayFormatLabel.translatesAutoresizingMaskIntoConstraints = false
        dayFormatLabel.textColor = Colors.labelColor
        dayFormatLabel.text = "Date Format"
        dayFormatLabel.numberOfLines = 1
        
        dayFormatSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        dayFormatSegmentedControl.replaceSegments(segments: dayFormatItems)
        dayFormatSegmentedControl.selectedSegmentIndex = 0
        dayFormatSegmentedControl.tintColor = .black
        dayFormatSegmentedControl.addTarget(self, action: #selector(self.dayFormatSegmentedControlChanged), for: UIControl.Event.valueChanged)
        
        dayFormatStackView.translatesAutoresizingMaskIntoConstraints = false
        dayFormatStackView.backgroundColor = Colors.viewColor
        dayFormatStackView.layer.cornerRadius = 8
        dayFormatStackView.axis = .vertical
        dayFormatStackView.spacing = 8
        dayFormatStackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        dayFormatStackView.isLayoutMarginsRelativeArrangement = true
    }
    
    func layout() {
        
        dayFormatStackView.addArrangedSubview(dayFormatLabel)
        dayFormatStackView.addArrangedSubview(dayFormatSegmentedControl)
     
        stackView.addArrangedSubview(dayFormatStackView)
        
        scrollView.addSubview(stackView)
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
           scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
           scrollView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
           view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
           scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
               
           stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
           stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
           stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
           stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
           
           stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dayFormatStackView.heightAnchor.constraint(equalToConstant: 90),
        ])
    }
}
