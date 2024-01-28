import SwiftUI
import Foundation


struct DashboardView: View {
    @Binding var medications: [AppModels.DogMedicationRecord]
    @ObservedObject var groomingViewModel: GroomingViewModel

    @State private var showingFilterSheet = false
    @State private var selectedMenuItems: Set<String> = []
    @State private var selectedView: String?
    @State private var showingGroomingView = false
    @State private var navigateGroomingView = false

    let allMenuItems = MenuDataModel.allMenuItems

    var filteredMenuItems: [MenuItem] {
        selectedMenuItems.isEmpty ? [] : allMenuItems.filter { selectedMenuItems.contains($0.title) && $0.title != "Grooming Log" }
    }

    // UserDefaults for persisting selected items
    private let selectedItemsKey = "SelectedMenuItems"

    init(medications: Binding<[AppModels.DogMedicationRecord]>, groomingViewModel: GroomingViewModel) {
        self._medications = medications
        self.groomingViewModel = groomingViewModel
        self._selectedMenuItems = State(initialValue: Set(UserDefaults.standard.stringArray(forKey: selectedItemsKey) ?? []))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Check if any menu item is selected
                    if !selectedMenuItems.isEmpty {
                        // Dedicated Grooming Activities Section
                        if selectedMenuItems.contains("Grooming Log") {
                            groomingSectionView()
                        }
                        
                        // Other Menu Items excluding Grooming Log
                        ForEach(filteredMenuItems, id: \.id) { item in
                            itemView(for: item)
                        }
                    } else {
                        Text("Select items to view details")
                            .font(.headline)
                            .padding()
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
            .onAppear {
                // Trigger sortedGroomingActivities computation.
                print("Accessing Sorted Activities on Appear")
                
                let _ = groomingViewModel.sortedGroomingActivities
            }
            .onChange(of: selectedMenuItems) { newValue in
                UserDefaults.standard.set(Array(newValue), forKey: selectedItemsKey)
            }
            .onChange(of: selectedView) { newValue in
                // Handle navigation based on the selected view
            }
        }
     
          }

    

    @ViewBuilder
    private func groomingSectionView() -> some View {
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
                    ForEach(Array(groomingViewModel.sortedGroomingActivities.enumerated()), id: \.element.id) { (index, activity) in
                        if let originalIndex = groomingViewModel.groomingActivities.firstIndex(where: { $0.id == activity.id }) {
                            GroomingCardView(groomingActivity: $groomingViewModel.groomingActivities[originalIndex], onComplete: {
                                groomingViewModel.groomingActivities[originalIndex].markAsCompleted()
                            })
                        }
                    }
                }
            }
        }
        .padding()
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

