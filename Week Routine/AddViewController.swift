//
//  AddNewViewController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 5.10.2022.
//

import UIKit

protocol UpdateDelegate {
    func updateTableView()
}

class AddViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let stackView = UIStackView()
    let titleTextField = UITextField()
    let dateTextField = UITextField()
    let saveButton = UIButton()
    let pickerView = UIPickerView()
    
    var delegate: UpdateDelegate?
    
    var day = "Every day"
    var hour = "00"
    var minute = "00"
    
    let days = ["Every day", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" ]
    
    let hours = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
    
    let minutes = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        addGestureRecognizer()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        titleTextField.becomeFirstResponder()
    }
    
    //MARK: - GestureRecognizer
    
    func addGestureRecognizer(){
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc func respondToSwipeGesture(gesture: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Layout

extension AddViewController {
    
    func style() {
        
        view.backgroundColor = UIColor(hex: "#d6d6d6")
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.isSecureTextEntry = false // true
        titleTextField.placeholder = "Title"
        //textField.delegate = self
        //textField.keyboardType = .asciiCapable
        titleTextField.backgroundColor = UIColor(hex: "#f6f6f6")
        titleTextField.addConstraint(titleTextField.heightAnchor.constraint(equalToConstant: 45))
        titleTextField.layer.cornerRadius = 8
        titleTextField.setLeftPaddingPoints(10)
        
        dateTextField.inputView = pickerView
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.isSecureTextEntry = false // true
        dateTextField.placeholder = "Date"
        dateTextField.backgroundColor = UIColor(hex: "#f6f6f6")
        dateTextField.addConstraint(dateTextField.heightAnchor.constraint(equalToConstant: 45))
        dateTextField.layer.cornerRadius = 8
        dateTextField.tintColor = .clear
        dateTextField.setLeftPaddingPoints(10)
        
        saveButton.backgroundColor = .darkGray
        saveButton.addConstraint(saveButton.heightAnchor.constraint(equalToConstant: 45))
        saveButton.layer.cornerRadius = 8
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }
    
    func layout() {
        
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(dateTextField)
        stackView.addArrangedSubview(saveButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

//MARK: - pickerView

extension AddViewController {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return days.count
        } else if component == 1 {
            return hours.count
        } else {
            return minutes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return days[row]
        } else if component == 1 {
            return hours[row]
        } else {
            return minutes[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            day = days[row]
        } else if component == 1 {
            hour = hours[row]
        } else {
            minute = minutes[row]
        }
        dateTextField.text = "\(day), \(hour):\(minute)"
    }
}


//MARK: - Actions

extension AddViewController {
    
    @objc func saveButtonPressed() {
        guard let _ = dateTextField.text else{return}
        guard let titleText = titleTextField.text else{return}
        
        RoutineBrain.shareInstance.addRoutine(title: titleText, day: day, hour: Int16(hour)!, minute: Int16(minute)!)
        delegate?.updateTableView()
        
        self.dismiss(animated: true, completion: nil)
    }
}

