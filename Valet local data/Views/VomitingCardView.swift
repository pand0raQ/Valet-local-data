
import SwiftUI

struct VomitingCardView: View {
    @State private var isExpanded = false
    @State private var lastVomitingEntry:VomitingData?
    @State private var navigateToVomitingView = false  // State to control navigation
    
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                // Display last vomit date and time
                VStack(alignment: .leading) {
                    if let entry = lastVomitingEntry {
                        Text("Last🤮 : \(entry.lastVomitDateTime, formatter: dateFormatter)")
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
            
            // Button to expand/collapse the card
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Text(isExpanded ? "Show Less" : "Show More")
            }
            .padding(.top, 8)
            
            // Expanded state: Link to view saved picture
            if isExpanded {
                NavigationLink("View Saved Picture", destination: VomitingImageView())
            }
            
            // Hidden Navigation Link for navigation to VomitingView
            NavigationLink(destination: VomitingView(), isActive: $navigateToVomitingView) {
                EmptyView()
            }
        }
        .onAppear {
            lastVomitingEntry = loadFromUserDefaults()
        }
        .padding()
        .frame(maxWidth: .infinity)
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
