//
//  DashboardView.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 24.12.2023.
//

import SwiftUI

struct DashboardView: View {
    let menuItems: [MenuItem] = [
        MenuItem(title: "Pooping", destination: AnyView(poopingView())),
        MenuItem(title: "Vomiting", destination: AnyView(VomitingView())),
        MenuItem(title: "Appetite", destination: AnyView(AppetiteView())),
        MenuItem(title: "Medication", destination: AnyView(MedicationView())),
        MenuItem(title: "Allergies", destination: AnyView(AllergiesView())),
        MenuItem(title: "Bitch cycle", destination: AnyView(BitchcycleView())),
        MenuItem(title: "Grooming", destination: AnyView(GroomingView())),
        MenuItem(title: "Behaviour", destination: AnyView(BehaviourView())),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(menuItems, id: \.title) { item in
                    NavigationLink(destination: item.destination) {
                        Text(item.title)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Dashboard")
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
