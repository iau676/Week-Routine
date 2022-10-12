//
//  SettingsNewViewController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 6.10.2022.
//

import UIKit

protocol SettingsDelegate {
    func updateSettings()
}

class SettingsViewController: UIViewController {
        
    let titleLabel = UILabel()
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let allowNotificationButton = UIButton()
    let dayFormatStackView = UIStackView()
    let dayFormatLabel = UILabel()
    let dayFormatSegmentedControl = UISegmentedControl()
    let dayFormatItems = ["Sun", "VII", "7"]
    let selectedDayType = UserDefaults.standard.integer(forKey: "selectedDayType")
    let buttonImageSize = 18
    
    var delegate: SettingsDelegate?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        addGestureRecognizer()
        checkNotificationAllowed()
        
        updateIcon(allowNotificationButton, "next")
        allowNotificationButton.moveImageRightTextCenter()
    }
    
    //MARK: - Helpers
    
    func addGestureRecognizer(){
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    func checkNotificationAllowed() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    self.allowNotificationButton.isHidden = true
                }
            } else {
                DispatchQueue.main.async {
                    self.allowNotificationButton.isHidden = false
                }
            }
        }
    }
    
    func updateIcon(_ button: UIButton, _ imageName: String) {
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate).withTintColor(UIColor.white)
        button.setImage(UIGraphicsImageRenderer(size: CGSize(width: buttonImageSize, height: buttonImageSize)).image { _ in
            image?.draw(in: CGRect(x: 0, y: 0, width: buttonImageSize, height: buttonImageSize)) }, for: .normal)
        
    }
    
    
    //MARK: - Selectors
    
    @objc func respondToSwipeGesture(gesture: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func allowNotificationButtonPressed(gesture: UISwipeGestureRecognizer) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func dayFormatSegmentedControlChanged(segment: UISegmentedControl) -> Void {
        switch segment.selectedSegmentIndex {
        case 0:
            UserDefaults.standard.set(0, forKey: "selectedDayType")
        case 1:
            UserDefaults.standard.set(1, forKey: "selectedDayType")
        case 2:
            UserDefaults.standard.set(2, forKey: "selectedDayType")
        default:
            break
        }
        delegate?.updateSettings()
    }
}

//MARK: - Layout

extension SettingsViewController {
    
    func style() {
        view.backgroundColor = Colors.backgroundColor
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = Colors.labelColor
        titleLabel.text = "Settings"
        titleLabel.numberOfLines = 1
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        
        allowNotificationButton.translatesAutoresizingMaskIntoConstraints = false
        allowNotificationButton.setTitle("Allow Notification", for: [])
        allowNotificationButton.backgroundColor = .darkGray
        allowNotificationButton.layer.cornerRadius = 10
        allowNotificationButton.addTarget(self, action: #selector(allowNotificationButtonPressed), for: .primaryActionTriggered)
        
        dayFormatLabel.translatesAutoresizingMaskIntoConstraints = false
        dayFormatLabel.textColor = Colors.labelColor
        dayFormatLabel.text = "Date Format"
        dayFormatLabel.numberOfLines = 1
        
        dayFormatSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        dayFormatSegmentedControl.replaceSegments(segments: dayFormatItems)
        dayFormatSegmentedControl.selectedSegmentIndex = 0
        dayFormatSegmentedControl.tintColor = .black
        dayFormatSegmentedControl.addTarget(self, action: #selector(self.dayFormatSegmentedControlChanged), for: UIControl.Event.valueChanged)
        dayFormatSegmentedControl.selectedSegmentIndex = selectedDayType
        
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
     
        stackView.addArrangedSubview(allowNotificationButton)
        stackView.addArrangedSubview(dayFormatStackView)
        
        scrollView.addSubview(stackView)
        
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
           titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 2),
           titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
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
            allowNotificationButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
