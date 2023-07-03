//
//  TimerController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 11.06.2023.
//

import UIKit
import AudioToolbox

protocol TimerControllerDelegate : AnyObject {
    func timerCompleted(routine: Routine)
}

final class TimerController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: TimerControllerDelegate?
    private let routine: Routine
    
    private let titleLabel = UILabel()
    private let stopButton = UIButton()
    private let timerView = UIView()
    
    var timerCounter: CGFloat = 0
    private var timeR = Timer()
    private lazy var totalSecond: CGFloat = CGFloat(routine.timerSeconds)
    
    //MARK: - Lifecycle
    
    init(routine: Routine) {
        self.routine = routine
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        addObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startTimer()
    }
    
    //MARK: - Selectors
    
    @objc private func stopButtonPressed() {
        timeR.invalidate()
        showStopAlert()
    }
    
    @objc func appMovedToBackground() {
        setNotification(remindSecond: totalSecond-timerCounter)
    }
    
    //MARK: - Helpers
    
    private func startTimer() {
        handleTimer()
        UDM.isTimerCompleted.set(false)
        self.timeR = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.handleTimer()
        })
    }
    
    private func handleTimer() {
        timerCounter += 1
        handleAnimation()
        if timerCounter >= totalSecond {
            handleStop()
        } else {
            updateStopButtonTitle()
        }
    }

    private func handleAnimation() {
        timerView.setHeightWithAnimation(view.bounds.height/totalSecond*timerCounter, animateTime: 1.5)
    }
    
    private func handleStop() {
        timeR.invalidate()
        stopButton.isHidden = true
        NotificationCenter.default.removeObserver(self)
        Player.shared.play(soundInt: Int(routine.soundInt))
        self.dismiss(animated: false)
        self.delegate?.timerCompleted(routine: self.routine)
    }
    
    private func updateStopButtonTitle() {
        stopButton.setTitle("\(RoutineBrain.shareInstance.getTimerString(for: Int(totalSecond-timerCounter)))", for: .normal)
    }
    
    private func showStopAlert() {
        let alert = UIAlertController(title: "Are you sure you want to stop timer?", message: "", preferredStyle: .alert)
        let actionStop = UIAlertAction(title: "Stop", style: .destructive) { (action) in
            NotificationCenter.default.removeObserver(self)
            UDM.isTimerCompleted.set(true)
            self.dismiss(animated: true)
        }
        let actionContinue = UIAlertAction(title: "Continue", style: UIAlertAction.Style.cancel) { (action) in
            self.startTimer()
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(actionStop)
        alert.addAction(actionContinue)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground),
                                               name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    func setNotification(remindSecond: CGFloat) {
        timeR.invalidate()
        self.dismiss(animated: false)
        if remindSecond > 0 {
            UDM.currentNotificationDate.set(Date())
            UDM.routineUUID.set(routine.uuid ?? "")
            UDM.lastTimerCounter.set(timerCounter)
            UDM.isTimerCompleted.set(false)
            NotificationManager.shared.setNotificationForTimer(remindSecond: remindSecond, routine: routine)
        }
    }
    
    private func style() {
        view.backgroundColor = Colors.viewColor
        timerView.backgroundColor = RoutineBrain.shareInstance.getColor(routine.color ?? ColorName.defaultt)
        
        titleLabel.text = routine.title
        titleLabel.textColor = Colors.labelColor
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        stopButton.titleLabel?.numberOfLines = 1
        stopButton.titleLabel?.adjustsFontSizeToFitWidth = true
        stopButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        stopButton.setTitle("\(RoutineBrain.shareInstance.getTimerString(for: Int(routine.timerSeconds)))", for: .normal)
        stopButton.titleLabel?.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 23)
        stopButton.backgroundColor = .systemRed
        stopButton.setTitleColor(.white, for: .normal)
        stopButton.layer.borderWidth = 6
        stopButton.layer.borderColor = UIColor.white.cgColor
        stopButton.setDimensions(width: 90, height: 90)
        stopButton.layer.cornerRadius = 90 / 2
        stopButton.addTarget(self, action: #selector(stopButtonPressed), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem()
    }
    
    private func layout() {
        view.addSubview(timerView)
        view.addSubview(titleLabel)
        view.addSubview(stopButton)
        
        titleLabel.centerX(inView: view)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                          right: view.rightAnchor, paddingTop: 16,
                          paddingLeft: 32, paddingRight: 32)
        
        timerView.anchor(bottom: view.bottomAnchor)
        timerView.setWidth(view.frame.width)
        timerView.setHeight(0)
        
        stopButton.centerY(inView: view)
        stopButton.centerX(inView: view)
    }
}
