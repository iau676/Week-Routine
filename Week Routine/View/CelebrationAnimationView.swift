//
//  CelebrationAnimationView.swift
//  Week Routine
//
//  Created by ibrahim uysal on 6.03.2024.
//

import Lottie
import UIKit

class CelebrationAnimationView: UIView {
    
    var animationView: LottieAnimationView
    
    init(fileName: String) {
        let animation = LottieAnimation.named(fileName)
        self.animationView = LottieAnimationView(animation: animation)
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleToFill
        addSubview(animationView)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            animationView.topAnchor.constraint(equalTo: topAnchor),
            animationView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func selectAnimation(withColorName colorName: String?) {
        
        var animationName = ""
        
        switch colorName {
        case ColorName.red:
            animationName = AnimationName.redBalloon
        case ColorName.orange:
            animationName = AnimationName.orangeBalloon
        case ColorName.yellow:
            animationName = AnimationName.yellowBalloon
        case ColorName.green:
            animationName = AnimationName.greenBalloon
        case ColorName.blue:
            animationName = AnimationName.blueBalloon
        case ColorName.purple:
            animationName = AnimationName.purpleBalloon
        default:
            switch traitCollection.userInterfaceStyle {
                case .light, .unspecified:
                    animationName = AnimationName.blackBalloon
                case .dark:
                    animationName = AnimationName.whiteBalloon
            @unknown default:
                print("DEBUG::@unknown default")
            }
        }
        
        self.animationView.animation = LottieAnimation.named(animationName)
    }
    
    func play(completion: @escaping (Bool) -> Void) {
        animationView.play(completion: completion)
    }
}
