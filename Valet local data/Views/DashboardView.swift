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
                if selectedMenuItems.contains("Grooming Log") {
                                groomingSectionView()
                                    // Apply specific styling here
                            }
                            if selectedMenuItems.contains("Medication Log") {
                                MedicationCardView(medications: $medications)
                                    // Apply specific styling here
                            }
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                               ForEach(filteredMenuItems, id: \.id) { item in
                                   switch item.title {
                                   case "Grooming Log", "Medication Log":
                                       EmptyView() // Exclude these from grid
                                   default:
                                       itemView(for: item)
                                           .frame(height: 195) // Keep a consistent height for squared items
                                   }
                               }
                           }
                           .padding(.horizontal)
                       }
                       .navigationTitle("Dashboard")
                       .toolbar {
                           ToolbarItem(placement: .navigationBarTrailing) {
                               Button(action: { showingFilterSheet = true }) {
                                   Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                       .font(.system(size: 28))
                               }
                           }
                       }
                       .sheet(isPresented: $showingFilterSheet) {
                           MenuSelectionView(selectedMenuItems: $selectedMenuItems, allMenuItems: allMenuItems)
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
                       .frame(width: 195, height: 195)
                       .cornerRadius(10)
        case "Vomiting Log":
            VomitingCardView()
                       .frame(width: 195, height: 195)
                       .cornerRadius(10)
        case "Appetite Log":
            AppetiteCardView()
                       .frame(width: 195, height: 195)
                       .cornerRadius(10)
        case "Medication Log":
            MedicationCardView(medications: $medications)
                .cornerRadius(10)
        case "Allergies Log":
            AllergiesCardView()
                       .frame(width: 195, height: 195)
                       .cornerRadius(10)
        case "Grooming Log":
            ForEach(groomingViewModel.groomingActivities.indices, id: \.self) { index in
                GroomingCardView(groomingActivity: $groomingViewModel.groomingActivities[index], onComplete: {
                    // This closure is called when an activity is marked as completed.
                    groomingViewModel.groomingActivities[index].markAsCompleted()
                    // Additional code to handle the completion can be added here.
                })
                .cornerRadius(10)
            }
        // ... other cases ...
        default:
            EmptyView()
        }
    }
}

// Implement the PoopingCardView, VomitingCardView, and MenuSelectionView as per your app's requirements.

