//
//  ContentView.swift
//  Raynic
//
//  Created by Hamza on 01/04/2024.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @StateObject var contentVC = ContentViewModel()
    
    @State private var currentPage = 0
    @State private var pageNumber = 1 // For displaying the current page number
    
    @State private var selectedVoice: AVSpeechSynthesisVoice?
    @State private var isDownloadingVoice = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                PageControlView(contentVC: contentVC, currentPage: $currentPage, pageNumber: $pageNumber)
                Spacer()
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
                .frame(width: geometry.size.width * 0.8)
            }
            .padding()
        }
        .onAppear {
            configureAudioSession()
            checkAvailableVoices()
        }
    }
    
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
    
    
    func speak(_ text: String) {
        guard let voice = selectedVoice else {
            print("No voice available")
            return
        }
        
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            synthesizer.speak(utterance)
        }
    }
    func checkAvailableVoices() {
        let voices = AVSpeechSynthesisVoice.speechVoices()
        if let preferredVoice = voices.first(where: { $0.language == "en-US" }) {
            selectedVoice = preferredVoice
        } else {
            downloadVoice()
        }
    }
    
    func downloadVoice() {
        // Implement voice download functionality here
        // This function will be called if the desired voice is not available
        // You can add UI elements to inform the user and initiate the download process
        print("Voice download functionality not implemented")
        // Set isDownloadingVoice to true to show UI elements for download progress
        isDownloadingVoice = true
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
