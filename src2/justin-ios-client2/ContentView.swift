import SwiftUI
import AVFoundation
import Foundation

// VERSION history:  (variable in Models/ContentViewModel.swift)
// 2024-08-06: Initial
// 2024-09-08: Adding 4 clicks to page.
// 2025-03-12: Home is renamed to "Top Menu"
// 2025-04-26: Explicitly emptying ring-buffer.  "Top menu" will clear the ring buffer.
// 2025-10-03: Claude refactored this prject.  No feature change.

struct ContentView: View {
    @StateObject var contentViewModel = ContentViewModel()
    @StateObject var audioPlayerService = AudioPlayerService()
    @State private var currentPage = 2
    @State private var pageNumber = 3
    @State var ringBuffer = RingBuffer<String>(count: 4)

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                NavigationButtons(
                    currentPage: $currentPage,
                    pageNumber: $pageNumber,
                    ringBuffer: $ringBuffer
                )
                .environmentObject(contentViewModel)
                .environmentObject(audioPlayerService)

                Spacer()

                PageGrid(
                    pageLabels: contentViewModel.pages[currentPage],
                    shortPressAction: { label in
                        playMP3(for: label)
                    },
                    longPressAction: { label in
                        playMP3AndSwitchPage(for: label)
                    }
                )
                .frame(width: geometry.size.width * 0.7)
                .padding(.leading, 100)
                .padding(.trailing, 50)
            }
            .padding()
        }
    }

    // Function to play MP3
    func playMP3(for label: String) {
        guard !label.isEmpty else { return }

        audioPlayerService.playMP3(for: label)

        ringBuffer.append(label)
        if ringBuffer.isFull() && ringBuffer.containsUniqueElement() {
            switch label {
            case "music":
                currentPage = 1
            case "eat":
                currentPage = 3
            case "drink":
                currentPage = 4
            default:
                print("No associated page for \(label)")
            }
        }
    }

    // Function to switch pages after playing MP3
    func playMP3AndSwitchPage(for label: String) {
        playMP3(for: label)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            switch label {
            case "music":
                currentPage = 1
            case "eat":
                currentPage = 3
            case "drink":
                currentPage = 4
            default:
                print("No associated page for \(label)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
