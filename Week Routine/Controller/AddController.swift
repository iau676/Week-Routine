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

private let reuseIdentifier = "ColorCell"

final class AddController: UIViewController {
    
    var routine: Routine?
    var delegate: UpdateDelegate?
    
    private let titleTextField = UITextField()
    private let dateTextField = UITextField()
    private let colorButton = UIButton()
    private let clearColorButton = UIButton()
    private let pickerView = UIPickerView()
    private let colorCV = makeCollectionView()
    private let setTimerButton = UIButton()
    private let deleteButton = UIButton()
    
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
    
    //MARK: - Selectors
    
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
        colorCV.isHidden = false
        setTimerButton.isHidden = true
    }
    
    @objc private func clearColorButtonPressed() {
        colorName = ColorName.defaultt
        updateGradientLayerColors(Colors.labelColor, Colors.labelColor)
        colorCV.isHidden = true
    }
    
    @objc private func setTimerButtonPressed() {
        print("DEBUG::setTimerButtonPressed")
    }
    
    @objc private func deleteButtonPressed() {
        showDeleteAlert(title: "Routine will be deleted", message: "This action cannot be undone") { _ in
            guard let routine = self.routine else { return }
            brain.deleteRoutine(routine)
            self.delegate?.updateCV()
            self.dismissView()
        }
    }
    
    //MARK: - Helpers
    
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
        colorButton.contentHorizontalAlignment = .left
        colorButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0);
        colorButton.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        
        clearColorButton.setDimensions(width: 50, height: 50)
        clearColorButton.layer.cornerRadius = 8
        clearColorButton.addTarget(self, action: #selector(clearColorButtonPressed), for: .touchUpInside)
        clearColorButton.setImageWithRenderingMode(image: Images.cross, width: 20, height: 20, color: .label)
        
        colorCV.delegate = self
        colorCV.dataSource = self
        colorCV.backgroundColor = .clear
        colorCV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        colorCV.isHidden = true
        
        setTimerButton.setHeight(50)
        setTimerButton.backgroundColor = .white
        setTimerButton.setTitle("Set Timer", for: .normal)
        setTimerButton.setTitleColor(.label, for: .normal)
        setTimerButton.layer.cornerRadius = 8
        setTimerButton.setImageWithRenderingMode(image: Images.next, width: 20, height: 20, color: .label)
        setTimerButton.addTarget(self, action: #selector(setTimerButtonPressed), for: .touchUpInside)
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        
        updateScreenByMode()
    }
    
    private func layout() {
        view.addSubview(colorCV)
        
        let stack = UIStackView(arrangedSubviews: [titleTextField, dateTextField, colorButton, setTimerButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 32,
                     paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(clearColorButton)
        clearColorButton.centerY(inView: colorButton)
        clearColorButton.anchor(right: colorButton.rightAnchor)
        
        colorCV.anchor(top: colorButton.bottomAnchor, left: view.leftAnchor,
                       bottom: view.bottomAnchor, right: view.rightAnchor,
                       paddingTop: -32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(deleteButton)
        deleteButton.setHeight(50)
        deleteButton.anchor(left: stack.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: stack.rightAnchor)
        
        setTimerButton.moveImageRightTextLeft()
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
        colorButton.setTitleColor(colorName == ColorName.defaultt ? Colors.viewColor : .white, for: .normal)
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
            deleteButton.isHidden = false
        } else {
            title = "New Routine"
            clearColorButton.isHidden = true
            deleteButton.isHidden = true
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

//MARK: - UICollectionViewDelegate/DataSource

extension AddController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.contentView.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        colorName = colorNames[indexPath.row]
        let color = colors[indexPath.row]
        updateGradientLayerColors(color, color)
        colorCV.isHidden = true
        setTimerButton.isHidden = false
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension AddController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.bounds.width-64)/6, height: view.frame.height)
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
