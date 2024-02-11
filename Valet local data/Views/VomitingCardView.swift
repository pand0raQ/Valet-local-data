
import SwiftUI

struct VomitingCardView: View {
    @State private var lastVomitingEntry: VomitingData?
    @State private var navigateToVomitingView = false  // State to control navigation
    
    var body: some View {
        VStack(alignment: .leading) {
            // Title indication for the card
            Text("Vomiting Log")
                .font(.headline)
                .padding(.bottom)
            
            VStack(alignment: .leading) {
                if let entry = lastVomitingEntry {
                    Text("Last🤮: \(entry.lastVomitDateTime, formatter: dateFormatter)")
                    // Displaying all information without needing to expand
                    NavigationLink("View Saved Picture", destination: VomitingImageView())
                } else {
                    Text("No data saved")
                }
            }
            
            Spacer()
            
            // Button to navigate to VomitingView
            Button(action: {
                navigateToVomitingView = true
            }) {
                Image(systemName: "plus.app.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.green)
            }
            .padding(.trailing, 16)
        }
        .onAppear {
            lastVomitingEntry = loadFromUserDefaults()
        }
        // Adjusting the frame to make the card a larger square
        .padding()
        .frame(width: 195, height: 195) // Adjust size by 30% from original proposal
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding()
    }

    private func loadFromUserDefaults() -> VomitingData? {
        guard let savedData = UserDefaults.standard.data(forKey: "VomitingDataArray") else { return nil }
        let decoder = JSONDecoder()
        if let loadedRecords = try? decoder.decode([VomitingData].self, from: savedData), !loadedRecords.isEmpty {
            return loadedRecords.last // Return the most recent entry
        }
        return nil
    }

    
    
    struct VomitingImageView: View {
        var body: some View {
            if let savedImageData = UserDefaults.standard.data(forKey: "vomitImageData"), // This key should ideally be unique for each vomiting entry
               let uiImage = UIImage(data: savedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
            } else {
                Text("No image saved")
                    .padding()
            }
        }
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}


struct VomitingCardView_Previews: PreviewProvider {
    static var previews: some View {
        VomitingCardView()
    }
}
