//
//  AudioPlayer.swift
//  justin-ios-client2
//
//  Service for audio playback
//

import Foundation
import AVFoundation

class AudioPlayerService: ObservableObject {
    @Published var audioPlayer: AVAudioPlayer?

    func playMP3(for label: String) {
        guard !label.isEmpty else { return }

        // Stop previous audio if playing
        if let previousPlayer = audioPlayer, previousPlayer.isPlaying {
            previousPlayer.stop()
        }

        guard let mp3URL = Bundle.main.url(forResource: label, withExtension: "mp3") else {
            print("MP3 file not found for '\(label)'")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: mp3URL)
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
}
