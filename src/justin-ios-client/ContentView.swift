//
//  ContentView.swift
//  justin-ios-client
//
//  Created by Raymond Yongsub Chung on 4/5/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {

    @StateObject var contentVC = ContentViewModel()

    @State private var currentPage = 2
    @State private var pageNumber = 3     // for displaying

    @State private var selectedVoice: AVSpeechSynthesisVoice?
    @State var audioPlayer : AVAudioPlayer?
    @State var ringBuffer = RingBuffer<String>(count: 4)
    
    var body: some View {
        
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Navigation Arrow/Reset
                PageControlView(contentVC: contentVC, currentPage: $currentPage, pageNumber: $pageNumber, ringbuffer: ringBuffer)
                
                // Should be Wider
                Spacer()
                //Spacer().frame(minWidth: 100)

                // 4x2 grid
                GridStack(rows: 2, columns: 4, spacing: 10) { row, col in
                    Button(action: {
                        speak(contentVC.pages[currentPage][row * 4 + col])
                    }) {
                        VStack(spacing: 10) {
                            Spacer()
                            Image(systemName: getImageName(for: contentVC.pages[currentPage][row * 4 + col]))
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text(contentVC.pages[currentPage][row * 4 + col])
                                .font(.system(size: 20, weight: .bold))
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .border(Color.black, width: 1)
                }
                .frame(width: geometry.size.width * 0.7)
                .padding(.leading, 100)
                .padding(.trailing, 50)
            }
            .padding()
        }
        .onAppear {
            configureAudioSession()
            checkAvailableVoices()
        }
    }

    // Function to configure AVAudioSession
        // Function to configure AVAudioSession
    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch {
            print("Error configuring AVAudioSession: \(error.localizedDescription)")
        }
    }
    
    
    func speak(_ word: String) {
        guard let mp3file = Bundle.main.url(forResource: "\(word)", withExtension: "mp3") else {
            print("MP3 file not found for '\(word)' ")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: mp3file)
            audioPlayer!.play()
            
            ringBuffer.append(word)
            if ringBuffer.isFull() && ringBuffer.containsUniqueElement() {
                if word == "music" {
                    currentPage = 1
                    pageNumber = 2
                    
                } else if word == "eat" {
                    currentPage = 3
                    pageNumber = 4
            
                } else if word == "drink" {
                    currentPage = 4
                    pageNumber = 5
      
                }
            }
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    func checkAvailableVoices() {
        let voices = AVSpeechSynthesisVoice.speechVoices()
        if let preferredVoice = voices.first(where: { $0.language == "en-US" }) {
            selectedVoice = preferredVoice
                }
    }

    

    private func getImageName(for text: String) -> String {
        // Use the imageNames dictionary to get the image name for the given text
        if let imageName = contentVC.imageNames[text] {
            return imageName
        } else {
            return "circle" // Default image name if not found
        }
    }

}

fileprivate struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let spacing: CGFloat
    let content: (Int, Int) -> Content
    
    init(rows: Int, columns: Int, spacing: CGFloat, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(0..<self.columns, id: \.self) { column in
                        BorderButton {
                            self.content(row, column)
                        }
                    }
                }
            }
        }
    }
}

fileprivate struct BorderButton<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .border(Color.black, width: 1)
    }
}


struct PageControlView: View {
    @ObservedObject var contentVC: ContentViewModel
    @Binding var currentPage: Int
    @Binding var pageNumber: Int
    @State var ringbuffer: RingBuffer<String>
    
    var body: some View {
        VStack(spacing: 10) {
            Button(action: {
                moveUp(by: 1)
                ringbuffer.append("up-arrow")
            }) {
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
                currentPage = 2
                pageNumber = 3 // Reset to Home (page 3)
                speakPageSummary()
            }) {
                Text("Home")
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 150, height: UIScreen.main.bounds.height * 0.2)
            }
            .border(Color.black)
            
            Spacer()
            
            Button(action: {
                moveDown(by: 1)
                ringbuffer.append("down-arrow")
            }) {
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
    func speakPageSummary() {
        let buttons = contentVC.pages[currentPage].joined(separator: ", ")
        let text = "\(buttons)"
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = AVSpeechUtteranceMaximumSpeechRate / 0.5 // Set to maximum speech rate
        speak(utterance)
    }
    
    func moveUp(by amount: Int) {
        if currentPage > 0 {
            currentPage -= amount
            pageNumber -= amount // Decrease page number when moving up
            speakPageSummary()
        }
    }
    
    func moveDown(by amount: Int) {
        if currentPage < contentVC.pages.count - amount {
            currentPage += amount
            pageNumber += amount // Increase page number when moving down
            speakPageSummary()
        }
    }
}



//#Preview {
//    ContentView()
//}


