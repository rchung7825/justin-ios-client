import SwiftUI
import AVFoundation
import Foundation

// VERSION history
// 2024-08-06: Initial
// 2024-09-08: Adding 4 clicks to page.
//

class ContentViewModel: ObservableObject {
    let build_version = "2024-09-08"
    
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

struct RingBuffer<T: Hashable> {
    private var array: [T?]
    private var writeIndex = 0
    
    init(count: Int) {
        array = Array(repeating: nil, count: count)
    }
    
    mutating func append(_ element: T) {
        array[writeIndex] = element
        writeIndex = (writeIndex + 1) % array.count
    }
    
    func isFull() -> Bool {
        return array.allSatisfy { $0 != nil }
    }
    
    func containsUniqueElement() -> Bool {
        let uniqueElements = Set(array.compactMap { $0 })
        return uniqueElements.count == 1
    }
    
    mutating func clear() {
        array = Array(repeating: nil, count: array.count)
        writeIndex = 0
    }
    
    func mostRecentEvent() -> T? {
        guard let lastElement = array[(writeIndex + array.count - 1) % array.count] else {
            return nil
        }
        return lastElement
    }
    
    func eventBeforeMostRecent() -> T? {
        let index = (writeIndex + array.count - 2) % array.count
        guard let element = array[index] else {
            // If buffer is not full, return nil
            return nil
        }
        return element
    }
    
}


struct ContentView: View {
    @StateObject var contentViewModel = ContentViewModel()
    @State private var currentPage = 2
    @State private var pageNumber = 3
    @State private var audioPlayer: AVAudioPlayer?
    
    @State var ringBuffer = RingBuffer<String>(count: 4)
    

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                NavigationButtons(currentPage: $currentPage, pageNumber: $pageNumber, audioPlayer: $audioPlayer)
                    .environmentObject(contentViewModel)

                Spacer()

                PageGrid(pageLabels: contentViewModel.pages[currentPage],
                         shortPressAction: { label in
                             playMP3(for: label)
                         },
                         longPressAction: { label in
                             playMP3AndSwitchPage(for: label)
                         })
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

        if let previousPlayer = audioPlayer, previousPlayer.isPlaying {
            previousPlayer.stop()
        }
        
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

    // Function to switch pages after playing MP3
    func playMP3AndSwitchPage(for label: String) {
        playMP3(for: label)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { // Add delay before switching page
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

struct NavigationButtons: View {
    @Binding var currentPage: Int
    @Binding var pageNumber: Int
    @Binding var audioPlayer: AVAudioPlayer?

    @EnvironmentObject var contentViewModel: ContentViewModel

    var body: some View {
        VStack(spacing: 10) {
            Button(action: {
                playMP3(for: "up")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { // Add delay before switching page
                    // Move up if not at the top page
                    if currentPage > 0 {
                        currentPage -= 1
                    }
                }
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
                playMP3(for: "home")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { // Add delay before switching page
                    currentPage = 2
                }
            }) {
                Text("Home\n" + contentViewModel.build_version)
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 150, height: UIScreen.main.bounds.height * 0.2)
            }
            .border(Color.black)

            Spacer()

            Button(action: {
                playMP3(for: "down")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { // Add delay before switching page
                    // Move down if not at the bottom page
                    if currentPage < contentViewModel.pages.count - 1 {
                        currentPage += 1
                    }
                }
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

    // Function to play MP3 for navigation buttons
    func playMP3(for label: String) {
        guard !label.isEmpty else { return }

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

struct PageGrid: View {
    let pageLabels: [String]
    let shortPressAction: (String) -> Void
    let longPressAction: (String) -> Void

    var body: some View {
        GridStack(rows: 2, columns: 4, spacing: 10) { row, col in
            let index = row * 4 + col
            let label = pageLabels[index]

            Button(action: {
                shortPressAction(label)
            }) {
                VStack(spacing: 10) {
                    Spacer()
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Text(label.isEmpty ? "Button \(index + 1)" : label)
                        .font(.system(size: 20, weight: .bold))
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .border(Color.black, width: 1)
            .simultaneousGesture(LongPressGesture().onEnded { _ in
                longPressAction(label)
            })
        }
    }
}

struct GridStack<Content: View>: View {
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
                        content(row, column)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

