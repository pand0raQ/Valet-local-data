//
//  MenuDataModel.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 30.12.2023.
//

import Foundation

// MenuDataModel.swift

import SwiftUI

struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let category: String
      //  let isExpandableCard: Bool = true  // Since all items are cards, this can be defaulted to true
}

class MenuDataModel {
    static let allMenuItems: [MenuItem] = [
        MenuItem(title: "Pooping Log", category: "Health"),
        MenuItem(title: "Vomiting Log", category: "Health"),
        MenuItem(title: "Appetite Log", category: "Health"),
        MenuItem(title: "Medication Log", category: "Health"),
        MenuItem(title: "Allergies Log", category: "Health"),


        
        // ... add more items as needed
    ]

    // Additional functionalities can be added here, such as methods to add, remove, or update menu items.
}
/*
MenuItem(title: "Pooping", category: "GutHealth", destination: AnyView(poopingView())),
MenuItem(title: "Poopingtwo", category: "GutHealth", destination: AnyView(PoopingCardView())),
MenuItem(title: "Vomiting", category: "GutHealth", destination: AnyView(VomitingView())),
MenuItem(title: "Appetite", category: "GutHealth", destination: AnyView(AppetiteView())),
MenuItem(title: "Medication", category: "Hospital", destination: AnyView(AppetiteView())),
MenuItem(title: "Allergies", category: "Diet", destination: AnyView(AppetiteView())),
MenuItem(title: "Grooming", category: "Diet", destination: AnyView(AppetiteView())),
MenuItem(title: "Behaviour", category: "Diet", destination: AnyView(AppetiteView())),
*/
