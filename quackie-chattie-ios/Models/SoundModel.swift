//
//  SoundModel.swift
//  quackie-chattie-ios
//
//  Created by Rey Aparece on 7/30/22.
//

import Foundation
import AVFAudio

class SoundModel {
    static let instance = SoundModel()
    private var audioPlayer: AVAudioPlayer?
    func play() {
        guard let url = Bundle.main.url(forResource: "quack", withExtension: ".mp3") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Could not play quack")
        }
    }
}
