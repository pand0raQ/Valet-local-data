//
//  SecondDashboardView.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 03.01.2024.
//



import SwiftUI

struct SecondDashboardView: View {
    var body: some View {
        NavigationStack {
            List {
                // Directly embedding PoopingCardView
                PoopingCardView()
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.vertical, 5)

                // Directly embedding VomitingCardView
                VomitingCardView()
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.vertical, 5)
            }
            .navigationTitle("Second Dashboard")
        }
    }
}

struct SecondDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        SecondDashboardView()
    }
}
