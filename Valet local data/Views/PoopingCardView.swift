import SwiftUI

struct PoopingCardView: View {
    @State private var isExpanded = false
    @State private var lastPoopingEntry: PoopingData?
    @State private var navigateToPoopingView = false  // State to control navigation
    
    let sharedUserDefaults = UserDefaults(suiteName: "group.valet.local.data")


    var body: some View {
        VStack(alignment: .leading) {
            // Title indication for the card
            Text("Pooping Log")
                .font(.headline)
                .padding(.bottom)

            VStack(alignment: .leading) {
                if let lastPooped = lastPoopingEntry?.lastPoopedDateTime {
                    Text("Last 💩: \(lastPooped, formatter: dateFormatter)")
                } else {
                    Text("Last 💩: No data saved")
                }
//                // Displaying all information without needing to expand
//                if let entry = lastPoopingEntry {
//                    Text("Consistency: \(entry.consist.rawValue)")
//                    Text("Consistency Comment: \(entry.consistComment)")
//                    Text("Color: \(entry.color)")
//                }
            }
            Spacer()
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
        .onAppear {
            lastPoopingEntry = loadFromUserDefaults()
        }
        // Adjusting the frame to make the card larger as requested
        .padding()
        .frame(width: 195, height: 195) // Increased size by 30%
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding()
    }


    private func loadFromUserDefaults() -> PoopingData? {
        // Attempt to fetch the data for the key "PoopingDataArray"
        if let savedData = sharedUserDefaults?.data(forKey: "PoopingDataArray") {
            let decoder = JSONDecoder()
            // Decode an array of PoopingData, not a single instance
            if let loadedRecords = try? decoder.decode([PoopingData].self, from: savedData), !loadedRecords.isEmpty {
                // Return the most recent entry
                return loadedRecords.last
            } else {
                print("Failed to decode PoopingData or no entries available")
            }
        } else {
            print("No PoopingData found in shared UserDefaults")
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
