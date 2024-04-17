import SwiftUI
import AVFoundation

class ContentViewModel: ObservableObject {
    let pages = [
        ["", "", "", "", "", "", "", ""],
        
        ["","","", "", "", "", "", ""],
        
        // Home
        ["eat", "music", "bathroom", "drink", "stop", "toy", "go", "different"],
       
        ["", "", "", "", "", "", "", ""],
        
        ["", "", "", "", "", "", "", ""]
        
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
