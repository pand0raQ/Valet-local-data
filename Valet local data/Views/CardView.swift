
// CardView.swift

import SwiftUI

struct CardView: View {
    @Binding var card: CardData

    var body: some View {
        VStack {
            Text(card.title)
                .font(.headline)
            if card.isExpanded {
                Text(card.details)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .onTapGesture {
            card.isExpanded.toggle()
        }
    }
}
