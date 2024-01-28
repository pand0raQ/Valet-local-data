

import Foundation
import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    @State private var medications: [AppModels.DogMedicationRecord] = []
    @StateObject var groomingViewModel = GroomingViewModel()

    var body: some View {
             TabView(selection: $selectedTab) {
                 DashboardView(medications: $medications, groomingViewModel: groomingViewModel)// Your existing Dashboard view
                     .tabItem {
                         Label("Dashboard", systemImage: "house.fill")
                
                     }
                     .tag(0)

                 CalendarView() // Your existing Calendar view
                     .tabItem {
                         Label("Calendar", systemImage: "calendar")
                     }
                     .tag(1)

                 ProfileView() // Your existing Profile view
                     .tabItem {
                         Label("Profile", systemImage: "person.fill")
                     }
                     .tag(2)
             }
        
          
        
         }
     }


