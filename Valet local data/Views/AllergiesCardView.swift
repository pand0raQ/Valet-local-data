

import SwiftUI

struct AllergiesCardView: View {
    @State private var isExpanded = false
    @State private var lastScratchingIntensityDate: Date?
    @State private var lastEyesDate: Date?
    @State private var lastRashDate: Date?
    @State private var navigateAllergiesCardView = false  // State to control navigation
    
    
    var body: some View {
          VStack(alignment: .leading) {
              Text("Allergies Summary")
                  .font(.headline)
                  .padding(.bottom)
              
              if let rashDate = lastRashDate {
                  Text("Last Rash: \(rashDate, formatter: dateFormatter)")
              } else {
                  Text("No Rash Data")
              }
              
              if let intensityDate = lastScratchingIntensityDate {
                  Text("Last Scratching: \(intensityDate, formatter: dateFormatter)")
              } else {
                  Text("No Scratching Data")
              }
              
              if let eyesDate = lastEyesDate {
                  Text("Last Eyes Issue: \(eyesDate, formatter: dateFormatter)")
              } else {
                  Text("No Eyes Data")
              }

              Spacer()
              
              Button(action: {
                  navigateAllergiesCardView = true
              }) {
                  Image(systemName: "plus.app.fill")
                      .resizable()
                      .frame(width: 24, height: 24)
                      .foregroundColor(.green)
              }
              .padding(.trailing, 16)
          }
          .onAppear {
              loadLastEntryDates()
          }
          // Adjusting to square size and style
          .padding()
          .frame(width: 195, height: 195) // Adjust size to match the other card views
          .background(Color.green.opacity(0.3))
          .foregroundColor(.black)
          .cornerRadius(10)
          .padding()
      }
    private func loadLastEntryDates() {
        if let rashData = UserDefaults.standard.data(forKey: "RashDataEntries"),
           let decodedRashData = try? JSONDecoder().decode([RashData].self, from: rashData),
           let lastRash = decodedRashData.sorted(by: { $0.dater > $1.dater }).first {
            lastRashDate = lastRash.dater
        }
        
        if let intensityData = UserDefaults.standard.data(forKey: "ScratchingIntensityDataEntries"),
           let decodedIntensityData = try? JSONDecoder().decode([ScratchingIntensityEntry].self, from: intensityData),
           let lastIntensity = decodedIntensityData.sorted(by: { $0.datescr > $1.datescr }).first {
            lastScratchingIntensityDate = lastIntensity.datescr
        }
        
        if let eyesData = UserDefaults.standard.data(forKey: "EyesDataEntries"),
           let decodedEyesData = try? JSONDecoder().decode([EyesData].self, from: eyesData),
           let lastEyes = decodedEyesData.sorted(by: { $0.dateeye > $1.dateeye }).first {
            lastEyesDate = lastEyes.dateeye
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    struct CenteredButtonStyle: ViewModifier {
        func body(content: Content) -> some View {
            HStack {
                Spacer()
                content
                Spacer()
            }
        }
    }
}
