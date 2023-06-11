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
    private let colorCV = makeCollectionView()
    private let timerTextField = UITextField()
    private let deleteButton = UIButton()
    
    private let datePickerView = CustomPickerView(type: .date)
    private let timerPickerView = CustomPickerView(type: .timer)
    
    private var dayInt = brain.getDayInt()
    private var day = days[brain.getDayInt()]
    private var hour = hours[brain.getHour()]
    private var minute = minutes[brain.getMinute()]
    private var colorName = ColorName.defaultt
    
    private var timerHour = "00"
    private var timerMin = "00"
    private var timerSec = "00"
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        configureDatePickerView()
        hideKeyboardWhenTappedAround()
    }
    
    //MARK: - Selectors
    
    @objc private func saveButtonPressed() {
        guard let dateText = dateTextField.text else { return }
        guard let titleText = titleTextField.text else { return }
        
        let hour = Int(hour) ?? 0
        let minute = Int(minute) ?? 0
        
        let tHour = Int(timerHour) ?? 0
        let tMin = Int(timerMin) ?? 0
        let tSec = Int(timerSec) ?? 0
        
        if titleText.count > 0 && dateText.count > 0 {
            if let routine = routine {
                brain.updateRoutine(routine: routine, title: titleText, day: dayInt, hour: hour, minute: minute,
                                    color: colorName, timerHour: tHour, timerMin: tMin, timerSec: tSec)
            } else {
                brain.addRoutine(title: titleText, day: dayInt, hour: hour, minute: minute,
                                 color: colorName, timerHour: tHour, timerMin: tMin, timerSec: tSec)
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
        timerTextField.isHidden = true
    }
    
    @objc private func clearColorButtonPressed() {
        colorName = ColorName.defaultt
        colorButton.backgroundColor = Colors.labelColor
        colorButton.setTitleColor(Colors.viewColor, for: .normal)
        clearColorButton.isHidden = true
        colorCV.isHidden = true
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
        
        datePickerView.delegate = self
        datePickerView.dataSource = self
        dateTextField.inputView = datePickerView
        dateTextField.placeholder = "Date"
        dateTextField.backgroundColor = Colors.viewColor
        dateTextField.layer.cornerRadius = 8
        dateTextField.tintColor = .clear
        dateTextField.setHeight(50)
        dateTextField.setLeftPaddingPoints(10)
        
        timerPickerView.delegate = self
        timerPickerView.dataSource = self
        timerTextField.inputView = timerPickerView
        timerTextField.placeholder = "Timer (Optional)"
        timerTextField.backgroundColor = Colors.viewColor
        timerTextField.layer.cornerRadius = 8
        timerTextField.tintColor = .clear
        timerTextField.setHeight(50)
        timerTextField.setLeftPaddingPoints(10)
        
        colorButton.setHeight(50)
        colorButton.layer.cornerRadius = 8
        colorButton.setTitle("Color", for: .normal)
        colorButton.setTitleColor(Colors.viewColor, for: .normal)
        colorButton.contentHorizontalAlignment = .left
        colorButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0);
        colorButton.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        colorButton.backgroundColor = Colors.labelColor
        
        clearColorButton.setDimensions(width: 50, height: 50)
        clearColorButton.layer.cornerRadius = 8
        clearColorButton.addTarget(self, action: #selector(clearColorButtonPressed), for: .touchUpInside)
        clearColorButton.setImageWithRenderingMode(image: Images.cross, width: 20, height: 20, color: .label)
        
        colorCV.delegate = self
        colorCV.dataSource = self
        colorCV.backgroundColor = .clear
        colorCV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        colorCV.isHidden = true
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        
        updateScreenByMode()
    }
    
    private func layout() {
        view.addSubview(colorCV)
        
        let stack = UIStackView(arrangedSubviews: [titleTextField, dateTextField, colorButton, timerTextField])
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
    
    private func configureDatePickerView() {
        let hour = Int(hour) ?? 0
        let minute = Int(minute) ?? 0
        datePickerView.selectRow(dayInt, inComponent: 0, animated: true)
        datePickerView.selectRow(hour, inComponent: 1, animated: true)
        datePickerView.selectRow(minute, inComponent: 2, animated: true)
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
            colorButton.backgroundColor = color
            clearColorButton.isHidden = false
            deleteButton.isHidden = false
        } else {
            title = "New Routine"
            clearColorButton.isHidden = true
            deleteButton.isHidden = true
        }
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
        colorButton.backgroundColor = color
        colorCV.isHidden = true
        clearColorButton.isHidden = false
        timerTextField.isHidden = false
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
        let customPickerView = pickerView as? CustomPickerView
        
        switch customPickerView?.type {
        case .date:
            switch component {
            case 0:  return days.count
            case 1:  return hours.count
            default: return minutes.count
            }
        case .timer:
            switch component {
            case 0:  return hours.count
            case 1:  return minutes.count
            default: return seconds.count
            }
        default: break
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let customPickerView = pickerView as? CustomPickerView
        
        switch customPickerView?.type {
        case .date:
            switch component {
            case 0:  return days[row]
            case 1:  return hours[row]
            default: return minutes[row]
            }
        case .timer:
            switch component {
            case 0:  return hours[row]
            case 1:  return minutes[row]
            default: return seconds[row]
            }
        default: break
        }
        return days[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let customPickerView = pickerView as? CustomPickerView
        
        switch customPickerView?.type {
        case .date:
            switch component {
            case 0:  day = days[row]
                     dayInt = row
            case 1:  hour = hours[row]
            default: minute = minutes[row]
            }
            dateTextField.text = "\(day), \(hour):\(minute)"
        case .timer:
            switch component {
            case 0:  timerHour = hours[row]
            case 1:  timerMin = minutes[row]
            default: timerSec = seconds[row]
            }
            timerTextField.text = "\(timerHour):\(timerMin):\(timerSec)"
        default: break
        }
    }
}
