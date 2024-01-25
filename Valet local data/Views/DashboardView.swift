

import SwiftUI

struct DashboardView: View {
    @Binding var medications: [AppModels.DogMedicationRecord]
    @ObservedObject var groomingViewModel: GroomingViewModel


   
    @State private var showingFilterSheet = false
    @State private var selectedMenuItems: Set<String> = []
    @State private var selectedView: String?
    @State private var showingGroomingView = false
    @State private var navigateGroomingView = false  // State for controlling navigation


    let allMenuItems = MenuDataModel.allMenuItems

       var filteredMenuItems: [MenuItem] {
           selectedMenuItems.isEmpty ? allMenuItems : allMenuItems.filter { selectedMenuItems.contains($0.title) }
       }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Grooming Activities Section
                    if selectedMenuItems.contains("Grooming Log") {
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Grooming Activities")
                                    .font(.headline)
                                Spacer()
                                NavigationLink(destination: GroomingView(groomingViewModel: groomingViewModel), isActive: $navigateGroomingView) {
                                               Button(action: {
                                                 navigateGroomingView = true
                                               }) {
                                                 Image(systemName: "gear")
                                                   .font(.headline)
                                               }
                                             }
                           
                                
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(groomingViewModel.groomingActivities.indices, id: \.self) { index in
                                        GroomingCardView(groomingActivity: $groomingViewModel.groomingActivities[index], onComplete: {
                                            // This closure is called when an activity is marked as completed.
                                            groomingViewModel.groomingActivities[index].markAsCompleted()
                                            // Additional code to handle the completion can be added here.
                                        })
                                    }
                                }
                            }
                        }
                        .padding()
                        
                        // Other Menu Items
                        ForEach(filteredMenuItems, id: \.id) { item in
                            // Exclude Grooming Activities from this loop
                            if item.title != "Grooming Log" {
                                itemView(for: item)
                            }
                        }
                    }
                }
                .navigationTitle("Dashboard")
                .navigationBarItems(trailing: Button(action: {
                    showingFilterSheet = true
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle.fill")
                        .font(.system(size: 28))
                })
                .sheet(isPresented: $showingFilterSheet) {
                    MenuSelectionView(selectedMenuItems: $selectedMenuItems, allMenuItems: allMenuItems)
                }
            }
            .onChange(of: selectedView) { newValue in
                // Handle navigation based on the selected view
                // For example, present a view modally or push onto a navigation stack
            }
        }
    }

    @ViewBuilder
    private func itemView(for menuItem: MenuItem) -> some View {
        switch menuItem.title {
        case "Pooping Log":
            PoopingCardView()
        case "Vomiting Log":
            VomitingCardView()
        case "Appetite Log":
            AppetiteCardView()
        case "Medication Log":
            MedicationCardView(medications: $medications)
        case "Allergies Log":
            AllergiesCardView()
        case "Grooming Log":
            ForEach(groomingViewModel.groomingActivities.indices, id: \.self) { index in
                GroomingCardView(groomingActivity: $groomingViewModel.groomingActivities[index], onComplete: {
                    // This closure is called when an activity is marked as completed.
                    groomingViewModel.groomingActivities[index].markAsCompleted()
                    // Additional code to handle the completion can be added here.
                })
            }
        // ... other cases ...
        default:
            EmptyView()
        }
    }
}

// Implement the PoopingCardView, VomitingCardView, and MenuSelectionView as per your app's requirements.

