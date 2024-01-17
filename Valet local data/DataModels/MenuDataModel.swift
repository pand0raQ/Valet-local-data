//
//  MenuDataModel.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 30.12.2023.
//



// MenuDataModel.swift
import Foundation

import SwiftUI

struct MenuItem: Identifiable {
    let id: UUID
    let title: String
    let category: String
    let icon: String

    init(title: String, category: String, icon: String = "") {
        self.id = UUID()
        self.title = title
        self.category = category
        self.icon = icon
    }
}

class MenuDataModel {
    static let allMenuItems: [MenuItem] = [
        MenuItem(title: "Pooping Log", category: "Health", icon: "icon1"),
        MenuItem(title: "Vomiting Log", category: "Health", icon: "icon2"),
        MenuItem(title: "Appetite Log", category: "Health", icon: "icon3"),
        MenuItem(title: "Medication Log", category: "Health", icon: "icon4"),
        MenuItem(title: "Allergies Log", category: "Health", icon: "icon5"),
        MenuItem(title: "Grooming Log", category: "Health", icon: "scissors")
        // ... add more items as needed
    ]
}
