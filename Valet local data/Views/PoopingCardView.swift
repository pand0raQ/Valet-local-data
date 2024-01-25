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
            lastPoopingEntry = loadFromUserDefaults()
            if let loadedData = loadFromUserDefaults() {
                    lastPoopingEntry = loadedData
                    print("Loaded data: \(loadedData)")
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
           if let savedData = sharedUserDefaults?.data(forKey: "PoopingData") {
               let decoder = JSONDecoder()
               if let loadedRecord = try? decoder.decode(PoopingData.self, from: savedData) {
                   return loadedRecord
               } else {
                   print("Failed to decode PoopingData")
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
