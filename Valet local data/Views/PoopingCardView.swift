import SwiftUI

struct PoopingCardView: View {
    @State private var isExpanded = false
    @State private var lastPoopingEntry: PoopingData?
    @State private var navigateToPoopingView = false  // State to control navigation

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // Left-side content
                VStack(alignment: .leading) {
                    if let entry = lastPoopingEntry {
                        Text("Last 💩: \(entry.lastPoopedDateTime, formatter: dateFormatter)")
                        
                        if isExpanded {
                            Text("Consistency: \(entry.consist.rawValue)")
                            Text("Consistency Comment: \(entry.consistComment)")
                            Text("Color: \(entry.color)")
                        }
                    } else {
                        Text("No data saved")
                    }
                }

                Spacer()

                // Button to navigate to poopingView
                Button(action: {
                    navigateToPoopingView = true
                }) {
                    Image(systemName: "plus.app.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.green)
                }
                .padding(.trailing, 16)
            }

            // Button to expand/collapse the card
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Text(isExpanded ? "Show Less" : "Show More")
            }
            .padding(.top, 8)

            // Navigation link (hidden)
            NavigationLink(destination: poopingView(), isActive: $navigateToPoopingView) {
                EmptyView()
            }
        }
        .onAppear {
            lastPoopingEntry = loadFromUserDefaults()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding()
    }

    private func loadFromUserDefaults() -> PoopingData? {
        if let savedData = UserDefaults.standard.data(forKey: "PoopingData") {
            let decoder = JSONDecoder()
            if let loadedRecord = try? decoder.decode(PoopingData.self, from: savedData) {
                return loadedRecord
            }
        }
        return nil
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

struct PoopingCardView_Previews: PreviewProvider {
    static var previews: some View {
        PoopingCardView()
    }
}
