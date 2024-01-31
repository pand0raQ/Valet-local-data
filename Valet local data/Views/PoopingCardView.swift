import SwiftUI

struct PoopingCardView: View {
    @State private var isExpanded = false
    @State private var lastPoopingEntry: PoopingData?
    @State private var navigateToPoopingView = false  // State to control navigation
    
    let sharedUserDefaults = UserDefaults(suiteName: "group.valet.local.data")


    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // Left-side content
                               VStack(alignment: .leading) {
                                   if let lastPooped = lastPoopingEntry?.lastPoopedDateTime {
                                       Text("Last 💩: \(lastPooped, formatter: dateFormatter)")
                                   } else {
                                       Text("Last 💩: No data saved")
                                   }
                                   
                                   if isExpanded, let entry = lastPoopingEntry {
                                       Text("Consistency: \(entry.consist.rawValue)")
                                       Text("Consistency Comment: \(entry.consistComment)")
                                       Text("Color: \(entry.color)")
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
            NavigationLink(destination: PoopingView(), isActive: $navigateToPoopingView) {
                EmptyView()
            }
        }
        .onAppear {
            // Load the most recent pooping entry from UserDefaults when the view appears
            lastPoopingEntry = loadFromUserDefaults()
            if lastPoopingEntry != nil {
                print("Loaded data: \(String(describing: lastPoopingEntry))")
            } else {
                print("No data found in UserDefaults")
            }
        }
        
        .padding()
        .frame(maxWidth: .infinity)
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
