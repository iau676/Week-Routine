//
//  AddNewViewController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 5.10.2022.
//

import UIKit

protocol UpdateDelegate {
    func updateCV()
}

final class AddController: UIViewController {
    
    var routine: Routine?
    var delegate: UpdateDelegate?
    
    private let titleTextField = UITextField()
    private let dateTextField = UITextField()
    private let colorButton = UIButton()
    private let clearColorButton = UIButton()
    private let pickerView = UIPickerView()
    
    private let colorPaletteView = UIView()
    private let redButton = UIButton()
    private let orangeButton = UIButton()
    private let yellowButton = UIButton()
    private let greenButton = UIButton()
    private let blueButton = UIButton()
    private let purpleButton = UIButton()
    
    private var dayInt = brain.getDayInt()
    private var day = days[brain.getDayInt()]
    private var hour = hours[brain.getHour()]
    private var minute = minutes[brain.getMinute()]
    private var colorName = ColorName.defaultt
    
    private let gradientLayer = CAGradientLayer()
    private var isGradientChanged = false
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        updatePickerView()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        setGradientSelectColorButton()
    }
    
    //MARK: - Helpers
    
    private func setGradientSelectColorButton() {
        gradientLayer.frame = colorButton.bounds
        if !isGradientChanged { gradientLayer.colors = [Colors.blue.cgColor, Colors.purple.cgColor] }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.cornerRadius = 8
        gradientLayer.locations = [0.0, 1.0]

        colorButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func updateGradientLayerColors(_ leftGradientColor: UIColor?, _ rightGradientColor: UIColor?) {
        let leftColor = leftGradientColor?.cgColor ?? UIColor.darkGray.cgColor
        let rightColor = rightGradientColor?.cgColor ?? UIColor.white.cgColor
        isGradientChanged = true
        clearColorButton.isHidden = false
        gradientLayer.colors = [leftColor, rightColor]
        colorButton.setTitleColor(colorName == ColorName.defaultt ? Colors.labelColor : .white, for: .normal)
    }
    
    private func updateScreenByMode() {
        if let routine = routine {
            title = "Edit Routine"
            
            dayInt = Int(routine.day)
            day = brain.getDayName(Int16(dayInt))
            hour = hours[Int(routine.hour)]
            minute = minutes[Int(routine.minute)]
            colorName = routine.color ?? ColorName.defaultt
            
            titleTextField.text = routine.title
            dateTextField.text = "\(day), \(hour):\(minute)"
            
            let color = brain.getColor(colorName)
            updateGradientLayerColors(color, color)
            clearColorButton.isHidden = false
        } else {
            title = "New Routine"
            clearColorButton.isHidden = true
        }
    }
    
    private func updatePickerView() {
        let hour = Int(hour) ?? 0
        let minute = Int(minute) ?? 0
        pickerView.selectRow(dayInt, inComponent: 0, animated: true)
        pickerView.selectRow(hour, inComponent: 1, animated: true)
        pickerView.selectRow(minute, inComponent: 2, animated: true)
    }
}

//MARK: - Layout

extension AddController {
    
    private func style() {
        configureBarButton()
        view.backgroundColor = Colors.backgroundColor
        
        titleTextField.placeholder = "Routine"
        titleTextField.backgroundColor = Colors.viewColor
        titleTextField.layer.cornerRadius = 8
        titleTextField.setHeight(50)
        titleTextField.setLeftPaddingPoints(10)
        titleTextField.becomeFirstResponder()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        dateTextField.inputView = pickerView
        dateTextField.placeholder = "Date"
        dateTextField.backgroundColor = Colors.viewColor
        dateTextField.layer.cornerRadius = 8
        dateTextField.tintColor = .clear
        dateTextField.setHeight(50)
        dateTextField.setLeftPaddingPoints(10)
        
        colorButton.setHeight(50)
        colorButton.layer.cornerRadius = 8
        colorButton.setTitle("Color", for: .normal)
        colorButton.setTitleColor(.white, for: .normal)
        colorButton.contentHorizontalAlignment = .left
        colorButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0);
        colorButton.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        
        clearColorButton.setDimensions(width: 50, height: 50)
        clearColorButton.layer.cornerRadius = 8
        clearColorButton.addTarget(self, action: #selector(clearColorButtonPressed), for: .touchUpInside)
        clearColorButton.setImageWithRenderingMode(image: Images.cross, width: 20, height: 20,
                                                   color: Colors.viewColor ?? .darkGray)
                
        colorPaletteView.backgroundColor = .darkGray
        colorPaletteView.isHidden = true
        
        redButton.backgroundColor = Colors.red
        redButton.addTarget(self, action: #selector(redButtonPressed), for: .touchUpInside)
        
        orangeButton.backgroundColor = Colors.orange
        orangeButton.addTarget(self, action: #selector(orangeButtonPressed), for: .touchUpInside)
        
        yellowButton.backgroundColor = Colors.yellow
        yellowButton.addTarget(self, action: #selector(yellowButtonPressed), for: .touchUpInside)
        
        greenButton.backgroundColor = Colors.green
        greenButton.addTarget(self, action: #selector(greenButtonPressed), for: .touchUpInside)
        
        blueButton.backgroundColor = Colors.blue
        blueButton.addTarget(self, action: #selector(blueButtonPressed), for: .touchUpInside)
        
        purpleButton.backgroundColor = Colors.purple
        purpleButton.addTarget(self, action: #selector(purpleButtonPressed), for: .touchUpInside)
        
        updateScreenByMode()
    }
    
    private func layout() {
        view.addSubview(colorPaletteView)
        
        let colorStack = UIStackView(arrangedSubviews: [redButton, orangeButton, yellowButton,
                                                        greenButton, blueButton, purpleButton])
        colorStack.axis = .horizontal
        colorStack.distribution = .fillEqually
        colorStack.spacing = 0
        colorPaletteView.addSubview(colorStack)
        
        let stack = UIStackView(arrangedSubviews: [titleTextField, dateTextField, colorButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 32,
                     paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(clearColorButton)
        clearColorButton.centerY(inView: colorButton)
        clearColorButton.anchor(right: colorButton.rightAnchor)
        
        colorPaletteView.anchor(top: colorButton.bottomAnchor, left: view.leftAnchor,
                                bottom: view.bottomAnchor, right: view.rightAnchor,
                                paddingTop: -32, paddingLeft: 32,
                                paddingBottom: 16, paddingRight: 32)
        
        colorStack.anchor(top: colorPaletteView.topAnchor, left: colorPaletteView.leftAnchor,
                      bottom: view.bottomAnchor, right: colorPaletteView.rightAnchor)
    }
    
    private func configureBarButton() {
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

//MARK: - UIPickerViewDataSource/Delegate

extension AddController: UIPickerViewDataSource, UIPickerViewDelegate {
    
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

extension AddController {
    
    @objc private func saveButtonPressed() {
        guard let dateText = dateTextField.text else { return }
        guard let titleText = titleTextField.text else { return }
        
        if titleText.count > 0 && dateText.count > 0 {
            if let routine = routine {
                let hour = Int(hour) ?? 0
                let minute = Int(minute) ?? 0
                brain.updateRoutine(routine: routine, title: titleText, day: dayInt, hour: hour, minute: minute, color: colorName)
            } else {
                brain.addRoutine(title: titleText, day: Int16(dayInt), hour: Int16(hour)!, minute: Int16(minute)!, color: colorName)
            }
            delegate?.updateCV()
            self.dismiss(animated: true, completion: nil)
        } else {
            if titleText.count == 0 && dateText.count == 0 {
                titleTextField.flash()
                dateTextField.flash()
            } else if titleText.count == 0 {
                titleTextField.flash()
            } else {
                dateTextField.flash()
            }
        }
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func colorButtonPressed() {
        colorPaletteView.isHidden = false
    }
    
    @objc private func clearColorButtonPressed() {
        colorName = ColorName.defaultt
        updateGradientLayerColors(Colors.viewColor, Colors.viewColor)
    }
    
    @objc private func redButtonPressed() {
        colorName = ColorName.red
        updateGradientLayerColors(Colors.red, Colors.red)
        colorPaletteView.isHidden = true
    }
    
    @objc private func orangeButtonPressed() {
        colorName = ColorName.orange
        updateGradientLayerColors(Colors.orange, Colors.orange)
        colorPaletteView.isHidden = true
    }
    
    @objc private func yellowButtonPressed() {
        colorName = ColorName.yellow
        updateGradientLayerColors(Colors.yellow, Colors.yellow)
        colorPaletteView.isHidden = true
    }
    
    @objc private func greenButtonPressed() {
        colorName = ColorName.green
        updateGradientLayerColors(Colors.green, Colors.green)
        colorPaletteView.isHidden = true
    }
    
    @objc private func blueButtonPressed() {
        colorName = ColorName.blue
        updateGradientLayerColors(Colors.blue, Colors.blue)
        colorPaletteView.isHidden = true
    }
    
    @objc private func purpleButtonPressed() {
        colorName = ColorName.purple
        updateGradientLayerColors(Colors.purple, Colors.purple)
        colorPaletteView.isHidden = true
    }

}
