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
    let contentView = UIView()
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
    let blueButton = UIButton()
    let purpleButton = UIButton()
    
    var delegate: UpdateDelegate?
    var isEditMode = false
    
    var routineTitle = ""
    var day = "Every day"
    var dayInt = RoutineBrain.shareInstance.getDayInt()
    var hour = "\(RoutineBrain.shareInstance.getHour())"
    var minute = "\(RoutineBrain.shareInstance.getMinute())"
    var colorName = ColorName.defaultt
    var routineArrayIndex = 0
    
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday", "Every day", "Weekday", "Weekend"]
    
    let hours = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
    
    let minutes = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]
    
    let gradientLayer = CAGradientLayer()
    var isGradientChanged = false
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        updatePickerView()
        addGestureRecognizer()
        hideKeyboardWhenTappedAround()
        updateScreenWhenKeyboardWillShow()
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
        clearColorButton.isHidden = false
        gradientLayer.colors = [topGradientColor?.cgColor ?? UIColor.darkGray.cgColor, bottomGradientColor?.cgColor ?? UIColor.white.cgColor]
        colorButtonBackgroundChanged()
    }
    
    private func updateScreenByMode() {
        day = RoutineBrain.shareInstance.getDayName(Int16(dayInt))
        hour = Int(hour) ?? 00 < 10 ? "0\(hour)" : "\(hour)"
        minute = Int(minute) ?? 00 < 10 ? "0\(minute)" : "\(minute)"
        if isEditMode == true {
            titleLabel.text = "Edit Routine"
            let color = RoutineBrain.shareInstance.getColor(colorName)
            titleTextField.text = routineTitle
            dateTextField.text = "\(day), \(hour):\(minute)"
            updateGradientLayerColors(color, color)
            clearColorButton.isHidden = false
        } else {
            titleLabel.text = "New Routine"
            clearColorButton.isHidden = true
        }
    }
    
    private func updatePickerView() {
        let hour = Int(hour) ?? 0
        let minute = Int(minute) ?? 0
        if isEditMode == true {
            pickerView.selectRow(dayInt, inComponent: 0, animated: true)
            pickerView.selectRow(hour, inComponent: 1, animated: true)
            pickerView.selectRow(minute, inComponent: 2, animated: true)
        } else {
            pickerView.selectRow(dayInt, inComponent: 0, animated: true)
            pickerView.selectRow(hour, inComponent: 1, animated: true)
            pickerView.selectRow(minute, inComponent: 2, animated: true)
            dateTextField.text = ""
        }
    }
    
    private func colorButtonBackgroundChanged(){
        if colorName == ColorName.defaultt {
            colorButton.setTitleColor(Colors.labelColor, for: .normal)
        } else {
            colorButton.setTitleColor(.white, for: .normal)
        }
    }
}

//MARK: - Layout

extension AddViewController {
    
    func style() {
        
        view.backgroundColor = Colors.darkBackground

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = Colors.backgroundColor
        contentView.layer.cornerRadius = 16
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = Colors.labelColor
        titleLabel.numberOfLines = 1
        
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
        titleTextField.backgroundColor = Colors.viewColor
        titleTextField.addConstraint(titleTextField.heightAnchor.constraint(equalToConstant: 45))
        titleTextField.layer.cornerRadius = 8
        titleTextField.setLeftPaddingPoints(10)
        titleTextField.becomeFirstResponder()
        
        pickerView.delegate = self
        pickerView.dataSource = self
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
        colorPaletteView.isHidden = true
        
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
        
        blueButton.translatesAutoresizingMaskIntoConstraints = false
        blueButton.backgroundColor = Colors.blue
        blueButton.addTarget(self, action: #selector(blueButtonPressed), for: .touchUpInside)
        
        purpleButton.translatesAutoresizingMaskIntoConstraints = false
        purpleButton.backgroundColor = Colors.purple
        purpleButton.addTarget(self, action: #selector(purpleButtonPressed), for: .touchUpInside)
        
        updateScreenByMode()
    }
    
    func layout() {
        
        //color palette
        colorPaletteStackView.addArrangedSubview(redButton)
        colorPaletteStackView.addArrangedSubview(orangeButton)
        colorPaletteStackView.addArrangedSubview(yellowButton)
        colorPaletteStackView.addArrangedSubview(greenButton)
        colorPaletteStackView.addArrangedSubview(blueButton)
        colorPaletteStackView.addArrangedSubview(purpleButton)
        
        view.addSubview(colorPaletteView)
        colorPaletteView.addSubview(colorPaletteStackView)
        
        //content view
        view.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(clearColorButton)
        
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(dateTextField)
        stackView.addArrangedSubview(colorButton)
        stackView.addArrangedSubview(saveButton)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 5*65-8),
            contentView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: contentView.trailingAnchor, multiplier: 2),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            clearColorButton.trailingAnchor.constraint(equalTo: colorButton.trailingAnchor, constant: -8),
            clearColorButton.topAnchor.constraint(equalTo: colorButton.topAnchor),
        ])
        
        NSLayoutConstraint.activate([
            colorPaletteView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            colorPaletteView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: colorPaletteView.trailingAnchor, multiplier: 2),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: colorPaletteView.bottomAnchor, multiplier: 2),

            colorPaletteStackView.topAnchor.constraint(equalTo: colorPaletteView.topAnchor),
            colorPaletteStackView.leadingAnchor.constraint(equalTo: colorPaletteView.leadingAnchor),
            colorPaletteStackView.trailingAnchor.constraint(equalTo: colorPaletteView.trailingAnchor),
            colorPaletteStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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


//MARK: - Selectors

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
                item.color = colorName
                RoutineBrain.shareInstance.updateRoutineNotification(routineArrayIndex)
                RoutineBrain.shareInstance.saveContext()
            } else {
                RoutineBrain.shareInstance.addRoutine(title: titleText, day: Int16(dayInt), hour: Int16(hour)!, minute: Int16(minute)!, color: colorName)
            }
            delegate?.updateTableView()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func colorButtonPressed() {
        colorPaletteView.isHidden = false
    }
    
    @objc func clearColorButtonPressed() {
        colorName = ColorName.defaultt
        updateGradientLayerColors(Colors.viewColor, Colors.viewColor)
    }
    
    @objc func redButtonPressed() {
        colorName = ColorName.red
        updateGradientLayerColors(Colors.red, Colors.red)
    }
    
    @objc func orangeButtonPressed() {
        colorName = ColorName.orange
        updateGradientLayerColors(Colors.orange, Colors.orange)
    }
    
    @objc func yellowButtonPressed() {
        colorName = ColorName.yellow
        updateGradientLayerColors(Colors.yellow, Colors.yellow)
    }
    
    @objc func greenButtonPressed() {
        colorName = ColorName.green
        updateGradientLayerColors(Colors.green, Colors.green)
    }
    
    @objc func blueButtonPressed() {
        colorName = ColorName.blue
        updateGradientLayerColors(Colors.blue, Colors.blue)
    }
    
    @objc func purpleButtonPressed() {
        colorName = ColorName.purple
        updateGradientLayerColors(Colors.purple, Colors.purple)
    }

}

//MARK: - Swipe Gesture

extension AddViewController {
    func addGestureRecognizer(){
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }

    @objc func respondToSwipeGesture(gesture: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Keyboard Will Show

 extension AddViewController {
     private func updateScreenWhenKeyboardWillShow(){
         NotificationCenter.default.addObserver(
             self,
             selector: #selector(keyboardWillShow),
             name: UIResponder.keyboardWillShowNotification,
             object: nil
         )
     }
     @objc func keyboardWillShow(notification: NSNotification) {
         if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
             let keyboardHeight = CGFloat(keyboardSize.height)
             NSLayoutConstraint.activate([
                 contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight),
             ])
             colorPaletteView.isHidden = true
         }
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
