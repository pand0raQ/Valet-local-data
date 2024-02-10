

import Foundation
import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    @State private var medications: [AppModels.DogMedicationRecord] = []
    @StateObject var groomingViewModel = GroomingViewModel()
  //  @State private var poopingLogs: [AppModels.PoopingData] = []
    @State  var poopingLogs: [PoopingData]

    

    var body: some View {
             TabView(selection: $selectedTab) {
                 DashboardView(medications: $medications, groomingViewModel: groomingViewModel)
                 
                     .tabItem {
                         Label("Dashboard", systemImage: "house.fill")
                
                     }
                     .tag(0)

                 CalendarView( ) // Your existing Calendar view
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


