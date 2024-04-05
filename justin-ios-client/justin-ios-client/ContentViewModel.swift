import SwiftUI
import AVFoundation

class ContentViewModel: ObservableObject {
    let pages = [
        // page 1
        ["Car", "Bike", "Bus", "Train", "Plane", "Boat", "Truck", "Scooter"],
        
        ["Goodbye","Hello","Please", "Thank you", "Sorry", "Help", "Bye", "See you"],
        
        // Home
        ["Eat", "Mat", "Bathroom", "Fix", "Walk", "Music", "Drink", "Different"],
       
        ["On", "Stop", "Toy", "Go", "Off", "Please", "Yes", "No"],
        
        ["Cat", "Dog", "Bird", "Fish", "Rabbit", "Turtle", "Hamster", "Guinea Pig"]
        
    ]
    
    // Dictionary mapping page names to system image names
    let imageNames: [String: String] = [
        "Eat": "leaf.fill",
        "Mat": "square.grid.2x2.fill",
        "Bathroom": "house.fill",
        "Fix": "hammer.fill",
        "Walk": "figure.walk",
        "Music": "music.note",
        "Drink": "drop.fill",
        "Different": "circle.fill",
        "On": "bolt.fill",
        "Stop": "stop.fill",
        "Toy": "gamecontroller.fill",
        "Go": "arrow.right.circle.fill",
        "Off": "power",
        "Please": "hand.raised.fill",
        "Yes": "checkmark.circle.fill",
        "No": "xmark.circle.fill",
        "Goodbye": "hand.wave.fill",
        "Hello": "hand.wave.fill",
        "Thank you": "hand.thumbsup.fill",
        "Sorry": "exclamationmark.triangle.fill",
        "Help": "questionmark.circle.fill",
        "Bye": "hand.wave.fill",
        "See you": "hand.wave.fill",
        "Cat": "cat.fill",
        "Dog": "dog.fill",
        "Bird": "bird.fill",
        "Fish": "drop.fill",
        "Rabbit": "hare.fill",
        "Turtle": "tortoise.fill",
        "Hamster": "hare.fill",
        "Guinea Pig": "hare.fill",
        "Car": "car.fill",
        "Bike": "bicycle",
        "Bus": "bus.fill",
        "Train": "tram.fill",
        "Plane": "airplane",
        "Boat": "shippingbox",
        "Truck": "shippingbox.fill",
        "Scooter": "bicycle.circle.fill"
    ]
    
    let synthesizer = AVSpeechSynthesizer()
}
