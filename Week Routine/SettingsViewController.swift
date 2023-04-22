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
            UserDefault.selectedDayType.set(0)
        case 1:
            UserDefault.selectedDayType.set(1)
        case 2:
            UserDefault.selectedDayType.set(2)
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
        
        titleLabel.textColor = Colors.labelColor
        titleLabel.text = "Settings"
        titleLabel.numberOfLines = 1
        
        stackView.axis = .vertical
        stackView.spacing = 16
        
        allowNotificationButton.setTitle("Allow Notification", for: [])
        allowNotificationButton.backgroundColor = Colors.blackColor
        allowNotificationButton.layer.cornerRadius = 10
        allowNotificationButton.addTarget(self, action: #selector(allowNotificationButtonPressed),
                                          for: .primaryActionTriggered)
        
        dayFormatLabel.textColor = Colors.labelColor
        dayFormatLabel.text = "Day Format"
        dayFormatLabel.numberOfLines = 1
        
        dayFormatSegmentedControl.replaceSegments(segments: dayFormatItems)
        dayFormatSegmentedControl.selectedSegmentIndex = 0
        dayFormatSegmentedControl.tintColor = .black
        dayFormatSegmentedControl.addTarget(self, action: #selector(dayFormatSegmentedControlChanged),
                                            for: .valueChanged)
        dayFormatSegmentedControl.selectedSegmentIndex = UserDefault.selectedDayType.getInt()
        
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
        
        titleLabel.anchor(top: view.topAnchor, paddingTop: 16)
        titleLabel.centerX(inView: view)
        
        scrollView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor,
                          bottom: view.bottomAnchor, right: view.rightAnchor,
                          paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        stackView.setWidth(view.frame.width-32)
        stackView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor,
                         bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor)
        
        dayFormatStackView.setHeight(90)
        allowNotificationButton.setHeight(40)
    }
}
