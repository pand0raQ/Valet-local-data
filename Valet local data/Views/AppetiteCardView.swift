//
//  AppetiteCardView.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 03.01.2024.
//

import SwiftUI

struct AppetiteCardView: View {
    @State private var lastRecordedAppetite: DogAppetiteRecord?
    @State private var navigateToAppetiteView = false  // State to control navigation

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    // Display last food and water given
                    if let appetiteRecord = lastRecordedAppetite {
                        Text("Food given: \(appetiteRecord.foodAmount) mg")
                        Text("Brand: \(appetiteRecord.foodBrand)")
                        Text("Water given: \(appetiteRecord.waterIntake) ml")
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
            lastRecordedAppetite = loadFromUserDefaults()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding()
    }

    private func loadFromUserDefaults() -> DogAppetiteRecord? {
        if let savedData = UserDefaults.standard.data(forKey: "DogAppetiteRecord"),
           let savedAppetiteRecord = try? JSONDecoder().decode(DogAppetiteRecord.self, from: savedData) {
            return savedAppetiteRecord
        }
        return nil
    }
}

struct AppetiteCardView_Previews: PreviewProvider {
    static var previews: some View {
        AppetiteCardView()
    }
}


#Preview {
    AppetiteCardView()
}
