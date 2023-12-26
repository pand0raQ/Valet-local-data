//
//  SavedResultsView.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 26.12.2023.
//

import SwiftUI

struct SavedResultsView: View {
    private var behaviorData: [String: Any]

    init() {
        behaviorData = UserDefaults.standard.object(forKey: "DogBehaviorData") as? [String: Any] ?? [:]
    }

    var body: some View {
        NavigationView {
            List(behaviorData.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                VStack(alignment: .leading) {
                    Text(key.replacingOccurrences(of: "_", with: " "))
                        .font(.headline)
                    Text("Value: \(stringify(value))")
                        .font(.subheadline)
                }
            }
            .navigationBarTitle("Saved Behavior Results")
        }
    }

    private func stringify(_ value: Any) -> String {
        if let intValue = value as? Int {
            return String(intValue)
        } else if let stringValue = value as? String {
            return stringValue
        } else {
            return "\(value)"
        }
    }
}

struct SavedResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedResultsView()
    }
}
