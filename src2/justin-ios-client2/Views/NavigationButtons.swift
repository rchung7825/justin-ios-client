//
//  NavigationButtons.swift
//  justin-ios-client2
//
//  Sidebar navigation buttons (Up, Top Menu, Down)
//

import SwiftUI

struct NavigationButtons: View {
    @Binding var currentPage: Int
    @Binding var pageNumber: Int
    @Binding var ringBuffer: RingBuffer<String>

    @EnvironmentObject var contentViewModel: ContentViewModel
    @EnvironmentObject var audioPlayerService: AudioPlayerService

    var body: some View {
        VStack(spacing: 10) {
            Button(action: {
                audioPlayerService.playMP3(for: "up")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
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
                audioPlayerService.playMP3(for: "top-menu")
                ringBuffer.clear()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    currentPage = 2
                }
            }) {
                Text("Top Menu\n" + contentViewModel.build_version)
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 150, height: UIScreen.main.bounds.height * 0.2)
            }
            .border(Color.black)

            Spacer()

            Button(action: {
                audioPlayerService.playMP3(for: "down")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
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
}
