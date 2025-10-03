//
//  ContentViewModel.swift
//  justin-ios-client2
//
//  Data model for pages and configuration
//

import Foundation
import AVFoundation

class ContentViewModel: ObservableObject {
    let build_version = "2025-10-03"

    let pages = [
        ["", "", "", "", "", "", "", ""],
        // "music" long-press will lead to this page:
        ["super-simple-songs","coco-melon","little-baby-bum", "bear-in-the-big-blue-house", "mickey-mouse", "super-why", "", ""],
        // Home
        ["eat", "music", "bathroom", "drink", "stop", "toy", "go", "different"],
        // "eat" long-press will lead to this:
        ["meal", "snack", "candy", "", "", "", "", ""],
        // "drink" will lead to this:
        ["water", "juice", "", "", "", "", "", "" ],
        // Only accessible by up/down navigation
        ["mario-kart", "asphalt-6", "mario-party", "", "", "", "", ""],
    ]

    // Dictionary mapping page names to system image names
    let imageNames: [String: String] = [
        "eat": "leaf.fill",
        "bathroom": "house.fill",
        "music": "music.note",
        "drink": "drop.fill",
        "different": "circle.fill",
        "stop": "stop.fill",
        "toy": "gamecontroller.fill",
        "go": "arrow.right.circle.fill",
    ]

    let synthesizer = AVSpeechSynthesizer()
}
