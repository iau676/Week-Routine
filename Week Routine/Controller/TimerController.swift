//
//  TimerController.swift
//  Week Routine
//
//  Created by ibrahim uysal on 11.06.2023.
//

import UIKit
import AudioToolbox

final class TimerController: UIViewController {
    
    //MARK: - Properties
    
    private let routine: Routine
    
    private let stopButton = UIButton()
    private let timerView = UIView()
    
    private var timeR = Timer()
    private var timerCounter: CGFloat = 0
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
        print("DEBUG::appMovedToBackground")
    }
    
    //MARK: - Helpers
    
    private func startTimer() {
        handleTimer()
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
        AudioServicesPlayAlertSound(SystemSoundID(1002))
        showCompletedAlert()
    }
    
    private func updateStopButtonTitle() {
        stopButton.setTitle("\(brain.getTimerString(for: Int(totalSecond-timerCounter)).dropFirst(2))", for: .normal)
    }
    
    private func showStopAlert() {
        let alert = UIAlertController(title: "Are you sure you want to stop timer?", message: "", preferredStyle: .alert)
        let actionStop = UIAlertAction(title: "Stop", style: .destructive) { (action) in
            NotificationCenter.default.removeObserver(self)
            self.navigationController?.popViewController(animated: true)
        }
        let actionContinue = UIAlertAction(title: "Continue", style: UIAlertAction.Style.cancel) { (action) in
            self.startTimer()
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(actionStop)
        alert.addAction(actionContinue)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showCompletedAlert() {
        showAlert(title: "Routine Completed", errorMessage: "") { OKpressed in
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground),
                                               name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    private func style() {
        title = routine.title
        view.backgroundColor = Colors.viewColor
        timerView.backgroundColor = brain.getColor(routine.color ?? ColorName.defaultt)
        
        stopButton.titleLabel?.numberOfLines = 1
        stopButton.titleLabel?.adjustsFontSizeToFitWidth = true
        stopButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        stopButton.setTitle("\(brain.getTimerString(for: Int(routine.timerSeconds)).dropFirst(2))", for: .normal)
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
        timerView.anchor(bottom: view.bottomAnchor)
        timerView.setWidth(view.frame.width)
        timerView.setHeight(0)
        
        view.addSubview(stopButton)
        stopButton.centerY(inView: view)
        stopButton.centerX(inView: view)
    }
}
