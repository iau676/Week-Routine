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
    
    let titleLabel = UILabel()
    
    let stackView = UIStackView()
    let titleTextField = UITextField()
    let dateTextField = UITextField()
    let colorButton = UIButton()
    let clearColorButton = UIButton()
    let saveButton = UIButton()
    let pickerView = UIPickerView()
    
    let colorPaletteView = UIView()
    let colorPaletteStackView = UIStackView()
    let redButton = UIButton()
    let orangeButton = UIButton()
    let yellowButton = UIButton()
    let greenButton = UIButton()
    let lightBlueButton = UIButton()
    let darkBlueButton = UIButton()
    let purpleButton = UIButton()
    
    var delegate: UpdateDelegate?
    var isEditMode = false
    
    var routineTitle = ""
    var day = "Every day"
    var dayInt = 0
    var hour = "00"
    var minute = "00"
    var color = ColorName.defaultt
    var routineArrayIndex = 0
    
    let days = ["Every day", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    let hours = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
    
    let minutes = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]
    
    var keyboardHeight: CGFloat { return UserDefault.keyboardHeight.getCGFloat() }
    var isGradientChanged = false
    
    let gradientLayer = CAGradientLayer()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        addGestureRecognizer()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        titleTextField.becomeFirstResponder()
        colorPaletteView.isHidden = true
        
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        setGradientSelectColorButton()
    }
    
    //MARK: - Helpers
    
    private func setGradientSelectColorButton(){
        let topGradientColor = UIColor(hex: "#645CAA") ?? .darkGray
        let bottomGradientColor = UIColor(hex: "#F07DEA") ?? .white

        gradientLayer.frame = colorButton.bounds
        if isGradientChanged == false {
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
        }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.cornerRadius = 8
        gradientLayer.locations = [0.0, 1.0]

        colorButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func updateGradientLayerColors(_ topGradientColor: UIColor?, _ bottomGradientColor: UIColor?){
        isGradientChanged = true
        gradientLayer.colors = [topGradientColor?.cgColor ?? UIColor.darkGray.cgColor, bottomGradientColor?.cgColor ?? UIColor.white.cgColor]
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
        
        view.backgroundColor = Colors.backgroundColor
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = Colors.labelColor
        titleLabel.numberOfLines = 1
        if isEditMode == true {
            titleLabel.text = "Edit Routine"
            let day = RoutineBrain.shareInstance.getDayName(Int16(dayInt))
            let color = RoutineBrain.shareInstance.getColor(color)
            let hour = Int(hour) ?? 00 < 10 ? "0\(hour)" : "\(hour)"
            let minute = Int(minute) ?? 00 < 10 ? "0\(minute)" : "\(minute)"
            titleTextField.text = routineTitle
            dateTextField.text = "\(day), \(hour):\(minute)"
            updateGradientLayerColors(color, color)
        } else {
            titleLabel.text = "New Routine"
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        colorPaletteStackView.translatesAutoresizingMaskIntoConstraints = false
        colorPaletteStackView.axis = .horizontal
        colorPaletteStackView.distribution = .fillEqually
        colorPaletteStackView.spacing = 0
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.isSecureTextEntry = false // true
        titleTextField.placeholder = "Routine"
        //textField.delegate = self
        //textField.keyboardType = .asciiCapable
        titleTextField.backgroundColor = Colors.viewColor
        titleTextField.addConstraint(titleTextField.heightAnchor.constraint(equalToConstant: 45))
        titleTextField.layer.cornerRadius = 8
        titleTextField.setLeftPaddingPoints(10)
        
        dateTextField.inputView = pickerView
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.isSecureTextEntry = false // true
        dateTextField.placeholder = "Date"
        dateTextField.backgroundColor = Colors.viewColor
        dateTextField.addConstraint(dateTextField.heightAnchor.constraint(equalToConstant: 45))
        dateTextField.layer.cornerRadius = 8
        dateTextField.tintColor = .clear
        dateTextField.setLeftPaddingPoints(10)
        
        saveButton.backgroundColor = Colors.blackColor
        saveButton.addConstraint(saveButton.heightAnchor.constraint(equalToConstant: 45))
        saveButton.layer.cornerRadius = 8
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        colorButton.addConstraint(colorButton.heightAnchor.constraint(equalToConstant: 45))
        colorButton.layer.cornerRadius = 8
        colorButton.setTitle("Color", for: .normal)
        colorButton.setTitleColor(.white, for: .normal)
        colorButton.contentHorizontalAlignment = .left
        colorButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0);
        colorButton.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        
        clearColorButton.translatesAutoresizingMaskIntoConstraints = false
        clearColorButton.addConstraint(clearColorButton.heightAnchor.constraint(equalToConstant: 45))
        clearColorButton.addConstraint(clearColorButton.widthAnchor.constraint(equalToConstant: 45))
        clearColorButton.layer.cornerRadius = 8
        clearColorButton.addTarget(self, action: #selector(clearColorButtonPressed), for: .touchUpInside)
        clearColorButton.setImageWithRenderingMode(image: Images.cross, width: 20, height: 20, color: Colors.viewColor ?? .darkGray)
                
        colorPaletteView.translatesAutoresizingMaskIntoConstraints = false
        colorPaletteView.backgroundColor = .darkGray
        
        redButton.translatesAutoresizingMaskIntoConstraints = false
        redButton.backgroundColor = Colors.red
        redButton.addTarget(self, action: #selector(redButtonPressed), for: .touchUpInside)
        
        orangeButton.translatesAutoresizingMaskIntoConstraints = false
        orangeButton.backgroundColor = Colors.orange
        orangeButton.addTarget(self, action: #selector(orangeButtonPressed), for: .touchUpInside)
        
        yellowButton.translatesAutoresizingMaskIntoConstraints = false
        yellowButton.backgroundColor = Colors.yellow
        yellowButton.addTarget(self, action: #selector(yellowButtonPressed), for: .touchUpInside)
        
        greenButton.translatesAutoresizingMaskIntoConstraints = false
        greenButton.backgroundColor = Colors.green
        greenButton.addTarget(self, action: #selector(greenButtonPressed), for: .touchUpInside)
        
        lightBlueButton.translatesAutoresizingMaskIntoConstraints = false
        lightBlueButton.backgroundColor = Colors.lightBlue
        lightBlueButton.addTarget(self, action: #selector(lightBlueButtonPressed), for: .touchUpInside)
        
        darkBlueButton.translatesAutoresizingMaskIntoConstraints = false
        darkBlueButton.backgroundColor = Colors.darkBlue
        darkBlueButton.addTarget(self, action: #selector(darkBlueButtonPressed), for: .touchUpInside)
        
        purpleButton.translatesAutoresizingMaskIntoConstraints = false
        purpleButton.backgroundColor = Colors.purple
        purpleButton.addTarget(self, action: #selector(purpleButtonPressed), for: .touchUpInside)
                
    }
    
    func layout() {
        
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(dateTextField)
        stackView.addArrangedSubview(colorButton)
        stackView.addArrangedSubview(saveButton)
        
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(clearColorButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 2),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 4),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight-16),
            
            clearColorButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            clearColorButton.topAnchor.constraint(equalTo: colorButton.topAnchor),
        ])
        
        colorPaletteStackView.addArrangedSubview(redButton)
        colorPaletteStackView.addArrangedSubview(orangeButton)
        colorPaletteStackView.addArrangedSubview(yellowButton)
        colorPaletteStackView.addArrangedSubview(greenButton)
        colorPaletteStackView.addArrangedSubview(lightBlueButton)
        colorPaletteStackView.addArrangedSubview(darkBlueButton)
        colorPaletteStackView.addArrangedSubview(purpleButton)
        
        view.addSubview(colorPaletteView)
        colorPaletteView.addSubview(colorPaletteStackView)
        
        NSLayoutConstraint.activate([
            colorPaletteView.heightAnchor.constraint(equalToConstant: keyboardHeight),
            colorPaletteView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            colorPaletteView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            colorPaletteView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            colorPaletteStackView.topAnchor.constraint(equalTo: colorPaletteView.topAnchor, constant: 0),
            colorPaletteStackView.leadingAnchor.constraint(equalTo: colorPaletteView.leadingAnchor, constant: 0),
            colorPaletteStackView.trailingAnchor.constraint(equalTo: colorPaletteView.trailingAnchor, constant: 0),
            colorPaletteStackView.bottomAnchor.constraint(equalTo: colorPaletteView.bottomAnchor, constant: 0),
        ])
    }
}

//MARK: - pickerView

extension AddViewController {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        dateTextField.text = "\(day), \(hour):\(minute)"
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
            dayInt = row
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
        guard let dateText = dateTextField.text else{return}
        guard let titleText = titleTextField.text else{return}
        
        if titleText.count > 0 && dateText.count > 0 {
            if isEditMode == true {
                let item =  RoutineBrain.shareInstance.routineArray[routineArrayIndex]
                item.title = titleText
                item.day = Int16(dayInt)
                item.hour = Int16(hour) ?? 00
                item.minute = Int16(minute) ?? 00
                item.color = color
                RoutineBrain.shareInstance.updateRoutineNotification(routineArrayIndex)
                RoutineBrain.shareInstance.saveContext()
            } else {
                RoutineBrain.shareInstance.addRoutine(title: titleText, day: Int16(dayInt), hour: Int16(hour)!, minute: Int16(minute)!, color: color)
            }
            delegate?.updateTableView()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func colorButtonPressed() {
        colorPaletteView.isHidden = false
    }
    
    @objc func clearColorButtonPressed() {
        color = ColorName.defaultt
        updateGradientLayerColors(Colors.viewColor, Colors.viewColor)
    }
    
    @objc func redButtonPressed() {
        color = ColorName.red
        updateGradientLayerColors(Colors.red, Colors.red)
    }
    
    @objc func orangeButtonPressed() {
        color = ColorName.orange
        updateGradientLayerColors(Colors.orange, Colors.orange)
    }
    
    @objc func yellowButtonPressed() {
        color = ColorName.yellow
        updateGradientLayerColors(Colors.yellow, Colors.yellow)
    }
    
    @objc func greenButtonPressed() {
        color = ColorName.green
        updateGradientLayerColors(Colors.green, Colors.green)
    }
    
    @objc func lightBlueButtonPressed() {
        color = ColorName.lightBlue
        updateGradientLayerColors(Colors.lightBlue, Colors.lightBlue)
    }
    
    @objc func darkBlueButtonPressed() {
        color = ColorName.darkBlue
        updateGradientLayerColors(Colors.darkBlue, Colors.darkBlue)
    }
    
    @objc func purpleButtonPressed() {
        color = ColorName.purple
        updateGradientLayerColors(Colors.purple, Colors.purple)
    }

}

//dismiss keyboard when user tap around
extension AddViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        colorPaletteView.isHidden = true
        view.endEditing(true)
    }
}
