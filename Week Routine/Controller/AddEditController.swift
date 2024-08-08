//
//  AddNewViewController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 5.10.2022.
//

import UIKit

private let reuseIdentifier = "ColorCell"

protocol AddControllerDelegate: AnyObject {
    func updateCV()
}

final class AddEditController: UIViewController {
    
    private var currrentIndex: Int
    var routine: Routine?
    weak var delegate: AddControllerDelegate?
    
    private let titleTextField = UITextField()
    private let dateTextField = UITextField()
    private let colorButton = UIButton()
    private let clearColorButton = UIButton()
    private let colorCV = makeCollectionView()
    private let deleteButton = UIButton()
    private let historyButton = UIButton()
    
    private let datePickerView = CustomPickerView(type: .date)
    private let soundPickerView = CustomPickerView(type: .sound)
    
    private let soundTextField = UITextField()
    private let soundLabel = UILabel()
    
    private let notificationLabel = makePaddingLabel(withText: "Notification")
    private let notificationSwitch = UISwitch()
    
    private let freezeLabel = makePaddingLabel(withText: "Freeze")
    private let freezeSwitch = UISwitch()
    
    private lazy var dayInt = currrentIndex-1
    private lazy var day = days[currrentIndex-1]
    private var hour = hours[getHour()]
    private var minute = minutes[getMinute()]
    private var colorName = ColorName.defaultt
    
    private var soundInt = 0
    
    //MARK: - Life Cycle
    
    init(currrentIndex: Int = 1) {
        self.currrentIndex = currrentIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        if titleText.count > 0 {
            if let routine = routine {
                brain.updateRoutine(routine: routine, title: titleText,
                                    day: dayInt, hour: hour,
                                    minute: minute, color: colorName,
                                    soundInt: soundInt)
            } else {
                brain.addRoutine(title: titleText, day: dayInt,
                                 hour: hour, minute: minute,
                                 color: colorName, soundInt: soundInt)
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
    
    @objc private func freezeChanged(sender: UISwitch) {
        guard let routine = self.routine else { return }
        RoutineBrain.shareInstance.updateFrozen(routine: routine)
        delegate?.updateCV()
        updateScreenByMode()
    }
    
    @objc private func notificationChanged(sender: UISwitch) {
        guard let routine = self.routine else { return }
        CoreDataManager.shared.updateNotificationOption(routine: routine)
        soundTextField.isEnabled = sender.isOn
        soundTextField.backgroundColor = sender.isOn ? Colors.viewColor : UIColor.darkGray.withAlphaComponent(0.2)
        delegate?.updateCV()
    }
    
    @objc private func historyButtonPressed() {
        guard let routine = self.routine else { return }
        let controller = LogController(routine: routine)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .formSheet
        self.present(nav, animated: true)
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
        titleTextField.setHeight(50)
        titleTextField.setLeftPaddingPoints(10)
        titleTextField.becomeFirstResponder()
        
        datePickerView.delegate = self
        datePickerView.dataSource = self
        dateTextField.inputView = datePickerView
        dateTextField.text = "\(day), \(hour):\(minute)"
        dateTextField.backgroundColor = Colors.viewColor
        dateTextField.tintColor = .clear
        dateTextField.setHeight(50)
        dateTextField.setLeftPaddingPoints(10)
        configureDatePickerView()
        
        colorButton.setHeight(50)
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
        soundTextField.layer.cornerRadius = 8
        soundTextField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        soundTextField.setHeight(50)
        soundTextField.setLeftPaddingPoints(10)
        
        soundLabel.text = "Default"
        soundLabel.textColor = .darkGray
        soundLabel.textAlignment = .right
        
        notificationLabel.setHeight(50)
        notificationLabel.backgroundColor = Colors.viewColor
        
        notificationSwitch.addTarget(self, action: #selector(notificationChanged), for: .valueChanged)
        
        freezeLabel.setHeight(50)
        freezeLabel.backgroundColor = Colors.viewColor
        freezeLabel.clipsToBounds = true
        freezeLabel.layer.cornerRadius = 8
        freezeLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        freezeSwitch.onTintColor = Colors.iceColor.withAlphaComponent(0.5)
        freezeSwitch.addTarget(self, action: #selector(freezeChanged), for: .valueChanged)
        
        historyButton.setTitle("History", for: .normal)
        historyButton.setTitleColor(.label, for: .normal)
        historyButton.backgroundColor = Colors.viewColor
        historyButton.clipsToBounds = true
        historyButton.layer.cornerRadius = 8
        historyButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        historyButton.addTarget(self, action: #selector(historyButtonPressed), for: .touchUpInside)
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.backgroundColor = Colors.viewColor
        deleteButton.clipsToBounds = true
        deleteButton.layer.cornerRadius = 8
        deleteButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        
        updateScreenByMode()
    }
    
    private func layout() {
        view.addSubview(colorCV)
        
        let stack = UIStackView(arrangedSubviews: [titleTextField, dateTextField, colorButton])
        stack.axis = .vertical
        stack.spacing = 1
        
        let secondStack = UIStackView(arrangedSubviews: [soundTextField, notificationLabel, freezeLabel])
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
        
        view.addSubview(notificationSwitch)
        notificationSwitch.centerY(inView: notificationLabel)
        notificationSwitch.anchor(right: view.rightAnchor, paddingRight: 32+16)
        
        view.addSubview(freezeSwitch)
        freezeSwitch.centerY(inView: freezeLabel)
        freezeSwitch.anchor(right: view.rightAnchor, paddingRight: 32+16)
        
        view.addSubview(soundLabel)
        soundLabel.centerY(inView: soundTextField)
        soundLabel.anchor(right: view.rightAnchor, paddingRight: 32+16)
        
        let bottomButtonStack = UIStackView(arrangedSubviews: [historyButton, deleteButton])
        bottomButtonStack.axis = .horizontal
        bottomButtonStack.spacing = 1
        bottomButtonStack.distribution = .fillEqually
        
        view.addSubview(bottomButtonStack)
        historyButton.setHeight(50)
        deleteButton.setHeight(50)
        bottomButtonStack.anchor(left: stack.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: stack.rightAnchor)
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
            
            soundInt = Int(routine.soundInt)
            soundLabel.text = sounds[soundInt]
            configureSoundPickerView()
            
            colorName = routine.color ?? ColorName.defaultt
            let color = getColor(colorName)
            colorButton.backgroundColor = color
            clearColorButton.isHidden = false
            historyButton.isHidden = false
            deleteButton.isHidden = false
            
            configureBarButton()
            
            if routine.isFrozen {
                freezeSwitch.isOn = routine.isFrozen
                notificationSwitch.isOn = !routine.isFrozen
                titleTextField.isEnabled = false
                dateTextField.isEnabled = false
                colorButton.isEnabled = false
                soundTextField.isEnabled = false
                dateTextField.backgroundColor = Colors.iceColor.withAlphaComponent(0.5)
                titleTextField.backgroundColor = Colors.iceColor.withAlphaComponent(0.5)
                colorButton.backgroundColor = Colors.iceColor.withAlphaComponent(0.5)
                soundTextField.backgroundColor = Colors.iceColor.withAlphaComponent(0.5)
                notificationLabel.backgroundColor = Colors.iceColor.withAlphaComponent(0.5)
                notificationSwitch.isEnabled = false
                colorButton.setTitleColor(Colors.labelColor, for: .normal)
                clearColorButton.isHidden = true
            } else {
                titleTextField.isEnabled = true
                dateTextField.isEnabled = true
                colorButton.isEnabled = true
                dateTextField.backgroundColor = Colors.viewColor
                titleTextField.backgroundColor = Colors.viewColor
                notificationLabel.backgroundColor = Colors.viewColor
                notificationSwitch.isEnabled = true
                colorButton.setTitleColor(Colors.viewColor, for: .normal)
                
                let isNotify = routine.isNotify
                notificationSwitch.isOn = isNotify
                soundTextField.isEnabled = isNotify
                soundTextField.backgroundColor = isNotify ? Colors.viewColor : UIColor.darkGray.withAlphaComponent(0.2)
            }
        } else {
            title = "New Routine"
            clearColorButton.isHidden = true
            historyButton.isHidden = true
            deleteButton.isHidden = true
            notificationLabel.isHidden = true
            notificationSwitch.isHidden = true
            freezeLabel.isHidden = true
            freezeSwitch.isHidden = true
            soundTextField.layer.cornerRadius = 8
            soundTextField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner,
                                                  .layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    private func updateViewsVisibility(bool: Bool) {
        soundTextField.isHidden = bool
        soundLabel.isHidden = bool
        guard let _ = routine else { return }
        notificationLabel.isHidden = bool
        notificationSwitch.isHidden = bool
        freezeLabel.isHidden = bool
        freezeSwitch.isHidden = bool
        historyButton.isHidden = bool
        deleteButton.isHidden = bool
    }
    
    private func configureDateValues(routine: Routine) {
        dayInt = Int(routine.day)
        day = getDayName(Int16(dayInt))
        hour = hours[Int(routine.hour)]
        minute = minutes[Int(routine.minute)]
    }
    
    private func configureDatePickerView() {
        let hour = Int(hour) ?? 0
        let min = Int(minute) ?? 0
        datePickerView.selectRow(dayInt, inComponent: 0, animated: true)
        datePickerView.selectRow(hour, inComponent: 1, animated: true)
        datePickerView.selectRow(min, inComponent: 2, animated: true)
    }
    
    private func configureSoundPickerView() {
        soundPickerView.selectRow(soundInt, inComponent: 0, animated: true)
    }
}

//MARK: - UICollectionViewDelegate/DataSource

extension AddEditController: UICollectionViewDataSource {
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
        updateViewsVisibility(bool: false)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension AddEditController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.bounds.width-64)/6, height: view.frame.height)
    }
}

//MARK: - UIPickerViewDataSource/Delegate

extension AddEditController: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
        case .sound:
            soundInt = row
            Player.shared.play(soundInt: row)
            soundLabel.text = sounds[row]
        default: break
        }
    }
}

//MARK: - LogControllerDelegate

extension AddEditController: LogControllerDelegate {
    func updateCV() {
        delegate?.updateCV()
    }
}
