
import SwiftUI

struct DashboardView: View {
    @Binding var medications: [AppModels.DogMedicationRecord]
    
    @State private var showingFilterSheet = false
    @State private var selectedMenuItems: Set<String> = []
    @State private var selectedView: String?  // State to track the selected view for navigation
    let allMenuItems = MenuDataModel.allMenuItems
    
    var filteredMenuItems: [MenuItem] {
        selectedMenuItems.isEmpty ? allMenuItems : allMenuItems.filter { selectedMenuItems.contains($0.title) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(filteredMenuItems, id: \.id) { item in
                        itemView(for: item)
                            .onTapGesture {
                                selectedView = item.title
                            }
                    }
                }
                .padding()
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
                
                
                // Add other cases as needed
            default:
                EmptyView()
            }
        }
    }
    

// Implement the PoopingCardView, VomitingCardView, and MenuSelectionView as per your app's requirements.

