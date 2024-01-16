import SwiftUI

struct MedicationCardView: View {
    @Binding var medications: [AppModels.DogMedicationRecord]
    @State private var isExpanded = true
    @State private var navigateToMedicationView = false
     @State private var navigateToScheduledNotificationsView = false
     @State private var isAnimating = false
    @State private var navigateToTimelineView = false

    private var nextMedicationEvent: (medicationName: String, dosage: String, date: Date)? {
        getNextMedicationEvent()
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    if let nextEvent = nextMedicationEvent {
                        Text("Next Medication: \(nextEvent.medicationName)")
                        Text("Dosage: \(nextEvent.dosage)")
                        Text("Scheduled: \(nextEvent.date, formatter: dateFormatter)")
                       
                    } else {
                        Text("No upcoming medication")
                    }
                }
                
                Spacer()
                // Checklist Button
                                Button(action: {
                                    // navigateToScheduledNotificationsView = true
                                    navigateToScheduledNotificationsView = true

                                    withAnimation(Animation.easeInOut(duration: 0.3).repeatCount(3, autoreverses: true)) {
                                        isAnimating = true
                                    }
                                }) {
                                    Image(systemName: "checklist")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.blue)
                                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                                }
                                .padding(.trailing, 16)
                // add medic Button
                Button(action: {
                    navigateToMedicationView = true
                }) {
                    Image(systemName: "plus.app.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.green)
                }
                .padding(.trailing, 16)
                // 
             
         
                    
            }
            
            .padding(.top, 8)
            
            NavigationLink(destination: MedicationView(), isActive: $navigateToMedicationView) {
                EmptyView()
            }
//            NavigationLink(destination: ScheduledMedicationsTimelineView(medications: $medications), isActive: $navigateToTimelineView) {
//                       EmptyView()
//                   }
            NavigationLink(destination: ScheduledNotificationsView(medications: $medications), isActive: $navigateToScheduledNotificationsView) {
                          EmptyView()
                      }
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.green.opacity(0.1))
        .cornerRadius(10)
        .padding()
        
        .onAppear {
            loadMedications()
            printMedicationDetails(medications)

                }
    }

    private func getNextMedicationEvent() -> (medicationName: String, dosage: String, date: Date)? {
        let now = Date()
        let upcomingEvents = medications.flatMap { medication -> [(String, String, Date)] in
            let times = (medication.dailyTimes ?? []) + (medication.irregularTimes ?? [])
            return times.compactMap { time in
                time.date > now ? (medication.medicationName, medication.dosage, time.date) : nil
            }
        }
        .filter { $0.2 > now }
        .sorted { $0.2 < $1.2 }

        return upcomingEvents.first
    }


    private func loadMedications() {
        if let savedItems = UserDefaults.standard.data(forKey: "SavedMedications") {
            do {
                let decodedItems = try JSONDecoder().decode([AppModels.DogMedicationRecord].self, from: savedItems)
                medications = decodedItems
                print("Loaded medications: \(medications)")

                // Debug print for daily and irregular times
                for medication in medications {
                    print("Medication: \(medication.medicationName), Dosage: \(medication.dosage)")

                    if let dailyTimes = medication.dailyTimes {
                        for time in dailyTimes {
                            print("Encoding NotificationTime - ID: \(time.timeId), Date: \(time.date)")

                            print("Daily time: \(time.date) for \(medication.medicationName)")
                        }
                    }

                    if let irregularTimes = medication.irregularTimes {
                        for time in irregularTimes {
                            print("Irregular time: \(time.date) for \(medication.medicationName)")
                        }
                    }
                }
            } catch {
                print("Error loading medications: \(error)")
            }
        } else {
            print("No saved medications data found.")
        }
    }
    
    func printMedicationDetails(_ medications: [AppModels.DogMedicationRecord]) {
        for medication in medications {
            print("Medication Name: \(medication.medicationName)")
            print("Dosage: \(medication.dosage)")
            print("Daily Times:")
            medication.dailyTimes?.forEach { dailyTime in
                print("  Date: \(dailyTime.date), Administered: \(dailyTime.administered)")
            }
            print("Irregular Times:")
            medication.irregularTimes?.forEach { irregularTime in
                print("  Date: \(irregularTime.date), Administered: \(irregularTime.administered)")
            }
        }
    }
   


    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

struct MedicationCardView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationCardView(medications: .constant([]))
    }
}

