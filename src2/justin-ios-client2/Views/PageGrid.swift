//
//  PageGrid.swift
//  justin-ios-client2
//
//  2x4 button grid for page content
//

import SwiftUI

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
