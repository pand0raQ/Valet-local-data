//
//  poopingStoredDataView.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 24.12.2023.
//

import SwiftUI

struct poopingStoredDataView: View {
    var body: some View {
        VStack {
            if let savedRecord = loadFromUserDefaults() {
                Text("Last Pooped Time: \(savedRecord.lastPoopedDateTime, formatter: dateFormatter)")
                Text("Consistency: \(savedRecord.consist.rawValue)")
                Text("Consistency Comment: \(savedRecord.consistComment)")
                Text("Color: \(savedRecord.color)")
                
            } else {
                Text("No data saved")
            }
        }
        .navigationBarTitle("Stored Data")
    }

    private func loadFromUserDefaults() -> DogHealthRecord? {
        if let savedData = UserDefaults.standard.data(forKey: "DogHealthRecord") {
            let decoder = JSONDecoder()
            if let loadedRecord = try? decoder.decode(DogHealthRecord.self, from: savedData) {
                return loadedRecord
            }
        }
        return nil
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .medium
    return formatter
}()


#Preview {
    poopingStoredDataView()
}
