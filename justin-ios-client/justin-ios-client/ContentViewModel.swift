import SwiftUI
import AVFoundation

class ContentViewModel: ObservableObject {
    let pages = [
        // page 1
        ["car", "bike", "bus", "train", "plane", "boat", "truck", "scooter"],
        
        ["goodbye","hello","please", "thank you", "sorry", "help", "bye", "see you"],
        
        // Home
        ["eat", "mat", "bathroom", "fix", "walk", "music", "drink", "different"],
       
        ["on", "stop", "toy", "go", "off", "please", "yes", "no"],
        
        ["cat", "dog", "bird", "fish", "rabbit", "turtle", "hamster", "guinea pig"]
        
    ]
    
    // Dictionary mapping page names to system image names
    let imageNames: [String: String] = [
        "eat": "leaf.fill",
        "mat": "square.grid.2x2.fill",
        "bathroom": "house.fill",
        "fix": "hammer.fill",
        "walk": "figure.walk",
        "music": "music.note",
        "drink": "drop.fill",
        "different": "circle.fill",
        "on": "bolt.fill",
        "stop": "stop.fill",
        "toy": "gamecontroller.fill",
        "go": "arrow.right.circle.fill",
        "off": "power",
        "please": "hand.raised.fill",
        "yes": "checkmark.circle.fill",
        "no": "xmark.circle.fill",
        "goodbye": "hand.wave.fill",
        "hello": "hand.wave.fill",
        "thank you": "hand.thumbsup.fill",
        "sorry": "exclamationmark.triangle.fill",
        "help": "questionmark.circle.fill",
        "bye": "hand.wave.fill",
        "see you": "hand.wave.fill",
        "cat": "cat.fill",
        "dog": "dog.fill",
        "bird": "bird.fill",
        "fish": "drop.fill",
        "rabbit": "hare.fill",
        "turtle": "tortoise.fill",
        "hamster": "hare.fill",
        "guinea pig": "hare.fill",
        "car": "car.fill",
        "bike": "bicycle",
        "bus": "bus.fill",
        "train": "tram.fill",
        "plane": "airplane",
        "boat": "shippingbox",
        "truck": "shippingbox.fill",
        "scooter": "bicycle.circle.fill"
    ]
    
    let synthesizer = AVSpeechSynthesizer()
}
