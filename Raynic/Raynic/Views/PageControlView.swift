//
//  PageControlView.swift
//  Raynic
//
//  Created by Hamza on 02/04/2024.
//

import SwiftUI
import AVFoundation

struct PageControlView: View {
    @ObservedObject var contentVC: ContentViewModel
    @Binding var currentPage: Int
    @Binding var pageNumber: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Button {
                speak("Up")
                if currentPage > 0 {
                    currentPage -= 1
                    pageNumber -= 1 // Decrease page number when moving up
                    speakAllButtonLabels()
                }
            } label: {
                VStack {
                    Spacer()
                    Image(systemName: "arrow.up")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .padding(.bottom)
                    
                    Text("Up")
                        .font(.system(size: 20, weight: .bold))
                    Spacer()
                }
                .frame(minWidth: 150, maxHeight: .infinity)
                .border(Color.black)
            }
            
            Spacer()
            
            Button(action: {
                speak("Reset")
                currentPage = 0
                pageNumber = 1 // Reset page number to 1 when resetting
                speakAllButtonLabels()
            }) {
                Text("Reset")
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 150, height: UIScreen.main.bounds.height * 0.2)
            }
            .border(Color.black)
            
            Spacer()
            
            Button {
                speak("Down")
                if currentPage < contentVC.pages.count - 1 {
                    currentPage += 1
                    pageNumber += 1 // Increase page number when moving down
                    speakAllButtonLabels()
                }
            } label: {
                VStack {
                    Spacer()
                    Image(systemName: "arrow.down")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .padding(.bottom)
                    Text("Down")
                        .font(.system(size: 20, weight: .bold))
                    Spacer()
                }
                .frame(minWidth: 150, maxHeight: .infinity)
                .border(Color.black)
            }
        }
    }
    
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        contentVC.synthesizer.speak(utterance)
    }
    
    func speak(_ utterance: AVSpeechUtterance) {
        contentVC.synthesizer.speak(utterance)
    }
    
    // Function to speak all button labels on the current page
    func speakAllButtonLabels() {
        let buttons = contentVC.pages[currentPage].joined(separator: ", ")
        let text = "You are now on page \(pageNumber). Buttons available on this page are: \(buttons)"
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = AVSpeechUtteranceMaximumSpeechRate / 1.6 // Set to maximum speech rate
        speak(utterance)
    }
}
