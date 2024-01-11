import SwiftUI
import UserNotifications


struct MedicationView: View {
    @State private var medicationName: String = ""
    @State private var dosage: String = ""
    @State private var scheduleType = "Daily"
    @State private var durationInWeeks = 1
    @State private var selectedTimes: [AppModels.NotificationTime] = [AppModels.NotificationTime(date: Date())]
    @State private var irregularDates: [AppModels.NotificationTime] = [AppModels.NotificationTime(date: Date())]
    @State private var medications: [AppModels.DogMedicationRecord] = []
    @State private var showScheduledNotifications = false
    @State private var showingDailyScheduleSuccessAlert = false
    @State private var showingIrregularScheduleSuccessAlert = false
    @State private var activeAlert: ActiveAlert?
    @State private var isAnimating: Bool = false
    
    enum ActiveAlert: Identifiable {
        case dailyScheduleSuccess, irregularScheduleSuccess
        
        // Identifiable conformance
        var id: Int {
            self.hashValue
        }
    }
    
    private let scheduleOptions = ["Daily", "Irregular Schedule"]
    
    private func updateSelectedTimes() {
        let calendar = Calendar.current
        let now = Date()
        selectedTimes = selectedTimes.map { notificationTime in
            let timeComponents = calendar.dateComponents([.hour, .minute], from: notificationTime.date)
            var nextTime = calendar.nextDate(after: now, matching: timeComponents, matchingPolicy: .nextTimePreservingSmallerComponents) ?? notificationTime.date
            
            if nextTime <= now {
                nextTime = calendar.date(byAdding: .day, value: 1, to: nextTime)!
            }
            
            return AppModels.NotificationTime(date: nextTime)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = calendar.timeZone
        selectedTimes.forEach { time in
            print("Next occurrence: \(dateFormatter.string(from: time.date))")
        }
    }
    
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Medication Info")) {
                    TextField("Medication Name", text: $medicationName)
                    TextField("Dosage (e.g., 2 pills)", text: $dosage)
                }
                
                Section(header: Text("Scheduling")) {
                    Picker("Schedule Type", selection: $scheduleType) {
                        ForEach(scheduleOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if scheduleType == "Daily" {
                        Picker("Duration", selection: $durationInWeeks) {
                            ForEach(1..<53, id: \.self) { week in
                                Text("\(week) week\(week > 1 ? "s" : "")")
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        ForEach(selectedTimes.indices, id: \.self) { index in
                            DatePicker(
                                "Time \(index + 1)",
                                selection: Binding(
                                    get: { self.selectedTimes[index].date },
                                    set: { newDate in
                                        self.selectedTimes[index].date = newDate
                                        self.selectedTimes[index].id = UUID() // Update the identifier if necessary
                                    }
                                ),
                                displayedComponents: .hourAndMinute
                            )
                        }
                        .onDelete(perform: deleteTime)
                        
                        Image(systemName: "plus.square.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.green)
                        //    .padding()
                            .onTapGesture {
                                addTime()
                                withAnimation(Animation.easeInOut(duration: 0.5).repeatCount(1, autoreverses: true)) {
                                    isAnimating.toggle()
                                }
                            }
                            .offset(y: isAnimating ? -5 : 0)
                        
                        //Button("Add Time", action: { addTime() })
                        
                        
                        Button("Schedule Daily Notifications", action: {
                            print("Selected Times for Daily Notifications: \(selectedTimes)")
                            updateSelectedTimes()
                            print("Updated Times for Daily Notifications: \(selectedTimes)")
                            scheduleDailyNotifications()
                        })
                        
                        
                        
                    } else {
                        ForEach(irregularDates.indices, id: \.self) { index in
                            DatePicker(
                                "Select Date \(index + 1)",
                                selection: Binding(
                                    get: { self.irregularDates[index].date },
                                    set: { newDate in
                                        self.irregularDates[index].date = newDate
                                        self.irregularDates[index].id = UUID() // Update the identifier if necessary
                                    }
                                ),
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(GraphicalDatePickerStyle())
                        }
                        
                        
                        
                        if !irregularDates.isEmpty {
                            ForEach(irregularDates, id: \.self) { date in
                                Text("Selected Date: \(date.date, formatter: dateFormatter)")
                            }
                        }
                        
                        ForEach(selectedTimes.indices, id: \.self) { index in
                            DatePicker(
                                "Time \(index + 1)",
                                selection: Binding(
                                    get: { self.selectedTimes[index].date },
                                    set: { newDate in
                                        self.selectedTimes[index].date = newDate
                                    }
                                ),
                                displayedComponents: .hourAndMinute
                            )
                        }
                        .onDelete(perform: deleteTime)
                        
                        
                        Image(systemName: "plus.square.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.green)
                        //    .padding()
                            .onTapGesture {
                                addTime()
                                withAnimation(Animation.easeInOut(duration: 0.5).repeatCount(1, autoreverses: true)) {
                                    isAnimating.toggle()
                                }
                            }
                            .offset(y: isAnimating ? -5 : 0)
                        
                        
                        Button("Schedule Irregular Notifications", action: {
                            print("Selected Dates for Irregular Notifications: \(irregularDates)")
                            print("Selected Times for Irregular Notifications: \(selectedTimes)")
                            scheduleIrregularNotifications()
                        })
                    }
                }
                Button("View Scheduled Notifications") {
                    showScheduledNotifications = true
                }
                NavigationLink(destination: ScheduledNotificationsView(medications: $medications), isActive: $showScheduledNotifications) {
                    EmptyView()
                }
            }
            .navigationBarTitle("Medications")
        }
        .alert(item: $activeAlert) { alertType in
            switch alertType {
            case .dailyScheduleSuccess:
                return Alert(
                    title: Text("Success"),
                    message: Text("Daily notifications scheduled successfully."),
                    dismissButton: .default(Text("OK"))
                )
            case .irregularScheduleSuccess:
                return Alert(
                    title: Text("Success"),
                    message: Text("Irregular notifications scheduled successfully."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onAppear {
            print("Loading medications")
            loadMedications()
        }
        
        
        // Additional view modifiers and functionality
    }
    
    private func deleteTime(at offsets: IndexSet) {
        selectedTimes.remove(atOffsets: offsets)
    }
    
    private func addTime() {
        selectedTimes.append(AppModels.NotificationTime(date: Date()))
    }
    private func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is a test notification."
        content.sound = UNNotificationSound.default
        
        // Schedule this notification to fire in 2 minutes
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling test notification: \(error)")
            } else {
                print("Test notification scheduled successfully.")
            }
        }
        resetForm()
        
    }
    
    private func scheduleDailyNotifications() {
        print("Starting to schedule daily notifications")

        // Adding medication
        print("Adding medication")
        addMedication()

        // Saving medication
        print("Saving medications")
        saveMedications()

        let notificationCenter = UNUserNotificationCenter.current()

        // Request permission to send notifications
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                // Schedule notifications if permission is granted
                print("Permission granted for notifications. Proceeding to schedule notifications.")
                self.scheduleNotifications(notificationCenter: notificationCenter)
                
                DispatchQueue.main.async {
                    print("Setting showingDailyScheduleSuccessAlert to true")
                    self.activeAlert = .dailyScheduleSuccess
                }
                
            } else if let error = error {
                // Handle the error case
                print("Error requesting notification authorization: \(error)")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    
    private func scheduleNotifications(notificationCenter: UNUserNotificationCenter) {
        print("Starting to schedule notifications")

        // Ensure there's a last medication to update
        guard let lastMedicationIndex = medications.indices.last else {
            print("No medication to schedule notifications for")
            return
        }

        for (index, notificationTime) in selectedTimes.enumerated() {
            print("Processing index: \(index)")

            let time = notificationTime.date // Access the Date object from NotificationTime
            let content = UNMutableNotificationContent()
            content.title = "Medication Reminder"
            content.body = "Time to take your medication: \(medicationName), \(dosage)"
            content.sound = UNNotificationSound.default

            for week in 0..<durationInWeeks {
                guard let triggerDate = Calendar.current.date(byAdding: .weekOfYear, value: week, to: time) else {
                    print("Failed to calculate trigger date")
                    continue
                }
                let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
                print("Calculated trigger date for time index \(index) and week \(week): \(triggerDate)")

                let notificationIdentifier = UUID().uuidString
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
                let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
                notificationCenter.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    } else {
                        print("Notification scheduled successfully with identifier \(notificationIdentifier)")
                    }
                }

                let updatedNotificationTime = AppModels.NotificationTime(date: time, identifier: notificationIdentifier)
                if scheduleType == "Daily" {
                    if index < (medications[lastMedicationIndex].dailyTimes?.count ?? 0) {
                        medications[lastMedicationIndex].dailyTimes?[index] = updatedNotificationTime
                    } else {
                        medications[lastMedicationIndex].dailyTimes?.append(updatedNotificationTime)
                    }
                } else {
                    if index < (medications[lastMedicationIndex].irregularTimes?.count ?? 0) {
                        medications[lastMedicationIndex].irregularTimes?[index] = updatedNotificationTime
                    } else {
                        medications[lastMedicationIndex].irregularTimes?.append(updatedNotificationTime)
                    }
                }
            }
        }

        saveMedications() // Save after updating all identifiers
        resetForm()
    }



    private func scheduleIrregularNotifications() {
        print("Starting to schedule irregular notifications")

        // Adding medication
        print("Adding medication")
        addMedication()

        // Saving medication
        print("Saving medications")
        saveMedications()

        let notificationCenter = UNUserNotificationCenter.current()

        // Request permission to send notifications
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted for notifications. Proceeding to schedule irregular notifications.")
                // Schedule notifications if permission is granted
                self.scheduleIrregularNotifications(notificationCenter: notificationCenter)
                
                DispatchQueue.main.async {
                    print("Setting showingIrregularScheduleSuccessAlert to true")
                    self.activeAlert = .irregularScheduleSuccess
                }
            } else if let error = error {
                // Handle the error case
                print("Error requesting notification authorization: \(error)")
            } else {
                print("Notification permission denied")
            }
        }
    }
    private func scheduleIrregularNotifications(notificationCenter: UNUserNotificationCenter) {
        print("Starting to schedule irregular notifications")

        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.body = "Time to take your medication: \(medicationName), \(dosage)"
        content.sound = UNNotificationSound.default

        // Assuming irregularDates and selectedTimes have the same count and corresponding indices
        for (index, dateNotificationTime) in irregularDates.enumerated() {
            guard index < selectedTimes.count,
                  let combinedDateTime = combineDateAndTime(date: dateNotificationTime.date, time: selectedTimes[index].date) else {
                continue // Skip if the date and time cannot be combined
            }

            let notificationIdentifier = UUID().uuidString
            let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: combinedDateTime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)

            let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
            notificationCenter.add(request) { error in
                if let error = error {
                    print("Error scheduling irregular notification: \(error)")
                } else {
                    print("Irregular notification scheduled successfully with identifier \(notificationIdentifier)")
                }
            }

            // Update the medication record with the new notification time
            let updatedNotificationTime = AppModels.NotificationTime(date: combinedDateTime, identifier: notificationIdentifier)
            if let lastMedicationIndex = medications.indices.last {
                if index < (medications[lastMedicationIndex].irregularTimes?.count ?? 0) {
                    medications[lastMedicationIndex].irregularTimes?[index] = updatedNotificationTime
                } else {
                    medications[lastMedicationIndex].irregularTimes?.append(updatedNotificationTime)
                }
                print("Updated irregularTimes: \(medications[lastMedicationIndex].irregularTimes)")
            }
        }

        resetForm()
        saveMedications() // Save after updating all identifiers
    }


    private func combineDateAndTime(date: Date, time: Date) -> Date? {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)

        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: date)
    }







    
    
    
    

    private func addMedication() {
        var newMedication: AppModels.DogMedicationRecord

        if scheduleType == "Daily" {
            newMedication = AppModels.DogMedicationRecord(
                medicationName: medicationName,
                dosage: dosage,
                scheduleType: scheduleType,
                durationInWeeks: durationInWeeks,
                dailyTimes: selectedTimes as? [AppModels.NotificationTime], // Casting to namespaced type
                irregularTimes: nil
            )
        } else {
            newMedication = AppModels.DogMedicationRecord(
                medicationName: medicationName,
                dosage: dosage,
                scheduleType: scheduleType,
                durationInWeeks: nil,
                dailyTimes: nil,
                irregularTimes: selectedTimes as? [AppModels.NotificationTime] // Casting to namespaced type
            )
        }

        medications.append(newMedication)
        print("Added new medication: \(medicationName)")
    }






    

    private func saveMedications() {
        print("Saving medications: \(medications)")

        do {
            let encoded = try JSONEncoder().encode(medications)
            UserDefaults.standard.set(encoded, forKey: "SavedMedications")
            print("Successfully saved medications.")
            if let savedData = UserDefaults.standard.data(forKey: "SavedMedications") {
                print("Data written to UserDefaults.")
            } else {
                print("Failed to write data to UserDefaults.")
            }
            
        } catch {
            print("Error saving medications: \(error)")
        }
    }

    

    private func loadMedications() {
        if let savedItems = UserDefaults.standard.data(forKey: "SavedMedications") {
            do {
                let decodedItems = try JSONDecoder().decode([AppModels.DogMedicationRecord].self, from: savedItems)
                medications = decodedItems
                print("Loaded medications: \(medications)")
            } catch {
                print("Error loading medications: \(error)")
            }
        } else {
            print("No saved medications data found.")
        }
    }



private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
    
    private func resetForm() {
        medicationName = ""
        dosage = ""
        scheduleType = "Daily" // or your default value
        durationInWeeks = 1 // or your default value
        selectedTimes = [AppModels.NotificationTime(date: Date())]
        irregularDates = [AppModels.NotificationTime(date: Date())]
    }
    


    // Custom ViewModifier for centering a button
    struct CenteredButtonStyle: ViewModifier {
        func body(content: Content) -> some View {
            HStack {
                Spacer()
                content
                Spacer()
            }
        }
    }


    
    }

    


  // Preview Provider
  struct MedicationView_Previews: PreviewProvider {
      static var previews: some View {
          MedicationView()
      }
  }



