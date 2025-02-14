//
//  Effects.swift
//  MindMazeExpedition
//
//  Created by jin fu on 14/02/25.
//

import Foundation
import AVFoundation

class ExpeditionEffects {
    
    static var shared = ExpeditionEffects()
    
    var player: AVAudioPlayer?

    func playSound() {
        let url = Bundle.main.url(forResource: "arrow", withExtension: "wav")

        do {
            player = try AVAudioPlayer(contentsOf: url!)
            guard let player = player else { return }

            player.prepareToPlay()
            player.play()

        } catch let error as NSError {
            print(error.description)
        }
    }
    
}
