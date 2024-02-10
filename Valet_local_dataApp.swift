import SwiftUI

@main
struct MyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State  var poopingLogs: [PoopingData] = []


    var body: some Scene {
        WindowGroup {
            ContentView(poopingLogs: poopingLogs)  // Your main view
          //  MedicationView()
        }
    }
}


