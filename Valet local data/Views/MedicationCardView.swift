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
                        if isExpanded {
                            Text("Scheduled: \(nextEvent.date, formatter: dateFormatter)")
                        }
                    } else {
                        Text("No upcoming medication")
                    }
                }
                
                Spacer()
                // Checklist Button
                                Button(action: {
                                    // navigateToScheduledNotificationsView = true
                                     navigateToTimelineView = true

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
            
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Text(isExpanded ? "Show Less" : "Show More")
            }
            .padding(.top, 8)
            
            NavigationLink(destination: MedicationView(), isActive: $navigateToMedicationView) {
                EmptyView()
            }
            NavigationLink(destination: ScheduledMedicationsTimelineView(medications: $medications), isActive: $navigateToTimelineView) {
                       EmptyView()
                   }
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
                }
    }

    private func getNextMedicationEvent() -> (medicationName: String, dosage: String, date: Date)? {
        let now = Date()
        print("Current Date and Time: \(now)")
        print("Medications Array: \(medications)")

        let upcomingEvents = medications.flatMap { medication -> [(String, String, Date)] in
            print("Checking medication: \(medication.medicationName)")

            let dailyEvents: [(String, String, Date)] = medication.dailyTimes?.compactMap { time in
                print("Daily time: \(time.date) for \(medication.medicationName)")
                return (medication.medicationName, medication.dosage, time.date)
            } ?? []

            let irregularEvents: [(String, String, Date)] = medication.irregularTimes?.compactMap { time in
                print("Irregular time: \(time.date) for \(medication.medicationName)")
                return (medication.medicationName, medication.dosage, time.date)
            } ?? []

            return dailyEvents + irregularEvents
        }
        .filter { eventDate in
            print("Evaluating Event: \(eventDate)")
            return eventDate.2 > now
        }
        .min(by: { $0.2 < $1.2 })

        print("Next Medication Event: \(String(describing: upcomingEvents))")
        return upcomingEvents
    }

    private func loadMedications() {
        if let savedData = UserDefaults.standard.data(forKey: "SavedMedications") {
            let decoder = JSONDecoder()
            if let loadedMedications = try? decoder.decode([AppModels.DogMedicationRecord].self, from: savedData) {
                self.medications = loadedMedications
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

