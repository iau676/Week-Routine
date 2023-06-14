//
//  AddNewViewController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 5.10.2022.
//

import UIKit

protocol AddControllerDelegate {
    func updateCV()
}

private let reuseIdentifier = "ColorCell"

final class AddController: UIViewController {
    
    var routine: Routine?
    var delegate: AddControllerDelegate?
    
    private let titleTextField = UITextField()
    private let dateTextField = UITextField()
    private let colorButton = UIButton()
    private let clearColorButton = UIButton()
    private let colorCV = makeCollectionView()
    private let timerTextField = UITextField()
    private let timerLabel = UILabel()
    private let deleteButton = UIButton()
    
    private let datePickerView = CustomPickerView(type: .date)
    private let timerPickerView = CustomPickerView(type: .timer)
    private let soundPickerView = CustomPickerView(type: .sound)
    
    private let soundTextField = UITextField()
    private let soundLabel = UILabel()
    
    private let freezeLabel = makePaddingLabel(withText: "Freeze")
    private let freezeSwitch = UISwitch()
    
    private var dayInt = brain.getDayInt()
    private var day = days[brain.getDayInt()]
    private var hour = hours[brain.getHour()]
    private var minute = minutes[brain.getMinute()]
    private var colorName = ColorName.defaultt
    
    private var timerHour = "00"
    private var timerMin = "00"
    private var timerSec = "00"
    
    private var soundInt = 0
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        hideKeyboardWhenTappedAround()
    }
    
    //MARK: - Selectors
    
    @objc private func saveButtonPressed() {
        guard let titleText = titleTextField.text else { return }
        
        let hour = Int(hour) ?? 0
        let minute = Int(minute) ?? 0
        
        let tHour = Int(timerHour) ?? 0
        let tMin = Int(timerMin) ?? 0
        let tSec = Int(timerSec) ?? 0
        
        if titleText.count > 0 {
            if let routine = routine {
                brain.updateRoutine(routine: routine, title: titleText, day: dayInt, hour: hour, minute: minute,
                                    color: colorName, timerHour: tHour, timerMin: tMin, timerSec: tSec, soundInt: soundInt)
            } else {
                brain.addRoutine(title: titleText, day: dayInt, hour: hour, minute: minute,
                                 color: colorName, timerHour: tHour, timerMin: tMin, timerSec: tSec, soundInt: soundInt)
            }
            delegate?.updateCV()
            self.dismiss(animated: true, completion: nil)
        } else {
            titleTextField.flash()
        }
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func colorButtonPressed() {
        colorCV.isHidden = false
        updateViewsVisibility(bool: true)
    }
    
    @objc private func clearColorButtonPressed() {
        colorName = ColorName.defaultt
        colorButton.backgroundColor = Colors.labelColor
        colorButton.setTitleColor(Colors.viewColor, for: .normal)
        clearColorButton.isHidden = true
        colorCV.isHidden = true
        updateViewsVisibility(bool: false)
    }
    
    @objc private func soundButtonPressed() {
        print("DEBUG::soundButtonPressed")
    }
    
    @objc private func freezeChanged(sender: UISwitch) {
        guard let routine = self.routine else { return }
        RoutineBrain.shareInstance.updateFrozen(routine: routine)
        delegate?.updateCV()
        updateScreenByMode()
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
        titleTextField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        titleTextField.setHeight(60)
        titleTextField.setLeftPaddingPoints(10)
        titleTextField.becomeFirstResponder()
        
        datePickerView.delegate = self
        datePickerView.dataSource = self
        dateTextField.inputView = datePickerView
        dateTextField.text = "\(day), \(hour):\(minute)"
        dateTextField.backgroundColor = Colors.viewColor
        dateTextField.tintColor = .clear
        dateTextField.setHeight(60)
        dateTextField.setLeftPaddingPoints(10)
        configureDatePickerView()
        
        timerPickerView.delegate = self
        timerPickerView.dataSource = self
        timerTextField.inputView = timerPickerView
        timerTextField.text = "Timer"
        timerTextField.backgroundColor = Colors.viewColor
        timerTextField.layer.cornerRadius = 8
        timerTextField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        timerTextField.tintColor = .clear
        timerTextField.setHeight(60)
        timerTextField.setLeftPaddingPoints(10)
        
        timerLabel.text = "00"
        timerLabel.textColor = .darkGray
        timerLabel.textAlignment = .right
        
        colorButton.setHeight(60)
        colorButton.layer.cornerRadius = 8
        colorButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
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
        
        soundPickerView.delegate = self
        soundPickerView.dataSource = self
        soundTextField.inputView = soundPickerView
        soundTextField.text = "Notification Sound"
        soundTextField.backgroundColor = Colors.viewColor
        soundTextField.tintColor = .clear
        soundTextField.setHeight(60)
        soundTextField.setLeftPaddingPoints(10)
        
        soundLabel.text = "Default"
        soundLabel.textColor = .darkGray
        soundLabel.textAlignment = .right
        
        freezeLabel.setHeight(60)
        freezeLabel.backgroundColor = Colors.viewColor
        freezeLabel.clipsToBounds = true
        freezeLabel.layer.cornerRadius = 8
        freezeLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        freezeSwitch.onTintColor = Colors.iceColor.withAlphaComponent(0.5)
        freezeSwitch.addTarget(self, action: #selector(freezeChanged), for: .valueChanged)
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        
        updateScreenByMode()
    }
    
    private func layout() {
        view.addSubview(colorCV)
        
        let stack = UIStackView(arrangedSubviews: [titleTextField, dateTextField, colorButton])
        stack.axis = .vertical
        stack.spacing = 1
        
        let secondStack = UIStackView(arrangedSubviews: [timerTextField, soundTextField, freezeLabel])
        secondStack.axis = .vertical
        secondStack.spacing = 1
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 16,
                     paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(secondStack)
        secondStack.anchor(top: stack.bottomAnchor, left: view.leftAnchor,
                           right: view.rightAnchor, paddingTop: 16,
                           paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(clearColorButton)
        clearColorButton.centerY(inView: colorButton)
        clearColorButton.anchor(right: colorButton.rightAnchor)
        
        colorCV.anchor(top: colorButton.bottomAnchor, left: view.leftAnchor,
                       bottom: view.bottomAnchor, right: view.rightAnchor,
                       paddingTop: -32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(timerLabel)
        timerLabel.centerY(inView: timerTextField)
        timerLabel.anchor(right: view.rightAnchor, paddingRight: 32+16)
        
        view.addSubview(freezeSwitch)
        freezeSwitch.centerY(inView: freezeLabel)
        freezeSwitch.anchor(right: view.rightAnchor, paddingRight: 32+16)
        
        view.addSubview(soundLabel)
        soundLabel.centerY(inView: soundTextField)
        soundLabel.anchor(right: view.rightAnchor, paddingRight: 32+16)
        
        view.addSubview(deleteButton)
        deleteButton.setHeight(50)
        deleteButton.anchor(left: stack.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: stack.rightAnchor)
    }
    
    private func configureBarButton() {
        let isFrozen: Bool = routine?.isFrozen ?? false
        
        navigationItem.rightBarButtonItem = isFrozen ? UIBarButtonItem() : UIBarButtonItem(barButtonSystemItem: .save,
                                                                                           target: self,
                                                                                           action: #selector(saveButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = Colors.labelColor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: isFrozen ? .close : .cancel,
                                                            target: self,
                                                            action: #selector(dismissView))
        navigationItem.leftBarButtonItem?.tintColor = Colors.labelColor
    }
    
    private func updateScreenByMode() {
        if let routine = routine {
            title = "Edit Routine"
            titleTextField.text = routine.title
            
            configureDateValues(routine: routine)
            configureDatePickerView()
            dateTextField.text = "\(day), \(hour):\(minute)"
            
            congifureTimerValues(routine: routine)
            configureTimerPickerView()
            timerLabel.text = getTimerString()
            
            soundInt = Int(routine.soundInt)
            soundLabel.text = sounds[soundInt]
            configureSoundPickerView()
            
            colorName = routine.color ?? ColorName.defaultt
            let color = brain.getColor(colorName)
            colorButton.backgroundColor = color
            clearColorButton.isHidden = false
            deleteButton.isHidden = false
            
            configureBarButton()
            if routine.isFrozen {
                freezeSwitch.isOn = routine.isFrozen
                titleTextField.isEnabled = false
                dateTextField.isEnabled = false
                timerTextField.isEnabled = false
                colorButton.isEnabled = false
                soundTextField.isEnabled = false
                dateTextField.backgroundColor = Colors.iceColor.withAlphaComponent(0.5)
                titleTextField.backgroundColor = Colors.iceColor.withAlphaComponent(0.5)
                timerTextField.backgroundColor = Colors.iceColor.withAlphaComponent(0.5)
                colorButton.backgroundColor = Colors.iceColor.withAlphaComponent(0.5)
                soundTextField.backgroundColor = Colors.iceColor.withAlphaComponent(0.5)
                colorButton.setTitleColor(Colors.labelColor, for: .normal)
                clearColorButton.isHidden = true
            } else {
                titleTextField.isEnabled = true
                dateTextField.isEnabled = true
                timerTextField.isEnabled = true
                colorButton.isEnabled = true
                soundTextField.isEnabled = true
                dateTextField.backgroundColor = Colors.viewColor
                titleTextField.backgroundColor = Colors.viewColor
                timerTextField.backgroundColor = Colors.viewColor
                soundTextField.backgroundColor = Colors.viewColor
                colorButton.setTitleColor(Colors.viewColor, for: .normal)
            }
        } else {
            title = "New Routine"
            clearColorButton.isHidden = true
            deleteButton.isHidden = true
            freezeLabel.isHidden = true
            freezeSwitch.isHidden = true
            soundTextField.layer.cornerRadius = 8
            soundTextField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    private func updateViewsVisibility(bool: Bool) {
        timerTextField.isHidden = bool
        soundTextField.isHidden = bool
        soundLabel.isHidden = bool
        timerLabel.isHidden = bool
        guard let _ = routine else { return }
        freezeLabel.isHidden = bool
        freezeSwitch.isHidden = bool
        deleteButton.isHidden = bool
    }
    
    private func configureDateValues(routine: Routine) {
        dayInt = Int(routine.day)
        day = brain.getDayName(Int16(dayInt))
        hour = hours[Int(routine.hour)]
        minute = minutes[Int(routine.minute)]
    }
    
    private func congifureTimerValues(routine: Routine) {
        let totalSeconds = routine.timerSeconds
        let hour = totalSeconds / 3600
        let min = (totalSeconds - (hour*3600)) / 60
        let sec = totalSeconds - ((hour*3600)+(min*60))
        
        timerHour = "\(hours[Int(hour)])"
        timerMin = "\(minutes[Int(min)])"
        timerSec = "\(seconds[Int(sec)])"
    }
    
    private func getTimerString() -> String {
        var hStr = Int(timerHour) ?? 0 > 0 ? "\(timerHour)\'" : ""
        let mStr = Int(timerMin) ?? 0 > 0 ? "\(timerMin)\"" : ""
        let sStr = Int(timerSec) ?? 0 > 0 ? timerSec : ""
        
        hStr.append(mStr)
        hStr.append(sStr)
        return hStr.count > 0 ? hStr : "Not Set"
    }
    
    private func configureDatePickerView() {
        let hour = Int(hour) ?? 0
        let min = Int(minute) ?? 0
        datePickerView.selectRow(dayInt, inComponent: 0, animated: true)
        datePickerView.selectRow(hour, inComponent: 1, animated: true)
        datePickerView.selectRow(min, inComponent: 2, animated: true)
    }
    
    private func configureTimerPickerView() {
        let hour = Int(timerHour) ?? 0
        let min = Int(timerMin) ?? 0
        let sec = Int(timerSec) ?? 0
        timerPickerView.selectRow(hour, inComponent: 0, animated: true)
        timerPickerView.selectRow(min, inComponent: 1, animated: true)
        timerPickerView.selectRow(sec, inComponent: 2, animated: true)
    }
    
    private func configureSoundPickerView() {
        soundPickerView.selectRow(soundInt, inComponent: 0, animated: true)
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
        updateViewsVisibility(bool: false)
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
        let customPickerView = pickerView as? CustomPickerView
        
        switch customPickerView?.type {
        case .sound:
            return 1
        default: break
        }
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
        case .sound:
            return sounds.count
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
            case 0:  return "\(hours[row]) hour"
            case 1:  return "\(minutes[row]) min"
            default: return "\(seconds[row]) sec"
            }
        case .sound:
            return sounds[row]
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
            timerLabel.text = getTimerString()
        case .sound:
            soundInt = row
            Player.shared.play(soundInt: row)
            soundLabel.text = sounds[row]
        default: break
        }
    }
}
