
import SwiftUI

struct AppetiteCardView: View {
    @State private var appetiteRecords: [DogAppetiteRecord] = [] // Updated to handle an array of records
    @State private var navigateToAppetiteView = false  // State to control navigation

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    // Display last food and water given from the most recent record
                    if let mostRecentRecord = appetiteRecords.last {
                        Text("Food given: \(mostRecentRecord.foodAmount) mg")
                        Text("Brand: \(mostRecentRecord.foodBrand)")
                        Text("Water given: \(mostRecentRecord.waterIntake) ml")
                    } else {
                        Text("No data saved")
                    }
                }

                Spacer()

                // Button to navigate to AppetiteView
                Button(action: {
                    navigateToAppetiteView = true
                }) {
                    Image(systemName: "plus.app.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.green)
                }
                .padding(.trailing, 16)
            }
            
            // Hidden Navigation Link for navigation to AppetiteView
            NavigationLink(destination: AppetiteView(), isActive: $navigateToAppetiteView) {
                EmptyView()
            }
        }
        .onAppear {
            loadFromUserDefaults()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding()
    }

    private func loadFromUserDefaults() {
        // Updated to load an array of DogAppetiteRecord
        if let savedData = UserDefaults.standard.data(forKey: "DogAppetiteRecordsArray"),
           let savedRecords = try? JSONDecoder().decode([DogAppetiteRecord].self, from: savedData) {
            appetiteRecords = savedRecords
        } else {
            appetiteRecords = [] // Ensure array is clear if no data is found
        }
    }
}

