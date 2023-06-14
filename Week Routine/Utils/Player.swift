//
//  Player.swift
//  Week Routine
//
//  Created by ibrahim uysal on 14.06.2023.
//

import Foundation
import AVFoundation

struct Player {
    static var shared = Player()
    private var player: AVAudioPlayer!
    
    mutating func play(with soundName: String) {
        let url = Bundle.main.url(forResource: "\(soundName)", withExtension: "m4a")
        player = try! AVAudioPlayer(contentsOf: url!)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
         print(error)
        }
        player.play()
    }
    
    mutating func play(soundInt: Int) {
        if soundInt > 0 && soundInt < 6 {
            play(with: sounds[soundInt])
        } else {
            if soundInt == 0 {
                AudioServicesPlayAlertSound(SystemSoundID(1002))
            }
        }
    }
    
    func stopSound() {
        guard let player = player else { return }
        player.stop()
    }
}
