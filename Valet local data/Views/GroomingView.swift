//
//  GroomingView.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 24.12.2023.
//
import SwiftUI
import UserNotifications

struct GroomingView: View {
    @State private var earCleaningInterval: Int = 4
    @State private var teethCleaningInterval: Int = 4
    @State private var pawsCleaningInterval: Int = 4
    @State private var bathInterval: Int = 4

    @State private var nextEarCleaningDate = Date()
    @State private var nextTeethCleaningDate = Date()
    @State private var nextPawsCleaningDate = Date()
    @State private var nextBathDate = Date()

    @State private var isScheduled = false

    var body: some View {
        NavigationView {
            Form {
                groomingSection(title: "Ears", interval: $earCleaningInterval, nextDate: $nextEarCleaningDate)
                groomingSection(title: "Teeth", interval: $teethCleaningInterval, nextDate: $nextTeethCleaningDate)
                groomingSection(title: "Paws", interval: $pawsCleaningInterval, nextDate: $nextPawsCleaningDate)
                groomingSection(title: "Bath", interval: $bathInterval, nextDate: $nextBathDate)

                Button("Schedule") {
                    scheduleGroomingTasks()
                }
                
                Button("Test Notification") {
                    testNotificationGrooming()
                }

                if isScheduled {
                    Section(header: Text("Scheduled Dates")) {
                        Text("Next Ear Cleaning: \(nextEarCleaningDate, formatter: DateFormatter.groomingScheduleDateFormatter) - \(countdownText(to: nextEarCleaningDate))")
                        Text("Next Teeth Cleaning: \(nextTeethCleaningDate, formatter: DateFormatter.groomingScheduleDateFormatter) - \(countdownText(to: nextTeethCleaningDate))")
                        Text("Next Paws Cleaning: \(nextPawsCleaningDate, formatter: DateFormatter.groomingScheduleDateFormatter) - \(countdownText(to: nextPawsCleaningDate))")
                        Text("Next Bath: \(nextBathDate, formatter: DateFormatter.groomingScheduleDateFormatter) - \(countdownText(to: nextBathDate))")
                    }
                }
            }
            .navigationBarTitle("Grooming Schedule")
        }
    }

    private func groomingSection(title: String, interval: Binding<Int>, nextDate: Binding<Date>) -> some View {
        Section(header: Text(title)) {
            Picker("Cleaning Interval (weeks)", selection: interval) {
                ForEach(1..<13, id: \.self) { // Adjust the range as needed
                    Text("\($0)").tag($0)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }

    private func scheduleGroomingTasks() {
        updateNextDate(for: "Ears", interval: earCleaningInterval, nextDate: $nextEarCleaningDate)
        updateNextDate(for: "Teeth", interval: teethCleaningInterval, nextDate: $nextTeethCleaningDate)
        updateNextDate(for: "Paws", interval: pawsCleaningInterval, nextDate: $nextPawsCleaningDate)
        updateNextDate(for: "Bath", interval: bathInterval, nextDate: $nextBathDate)
        isScheduled = true
        scheduleNotifications()
    }

    private func updateNextDate(for activity: String, interval: Int, nextDate: Binding<Date>) {
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .weekOfYear, value: interval, to: Date()) {
            nextDate.wrappedValue = newDate
        }
    }

    private func countdownText(to date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.month, .weekOfYear, .day], from: now, to: date)

        let months = components.month ?? 0
        let weeks = components.weekOfYear ?? 0
        let days = components.day ?? 0

        return "\(months) months, \(weeks) weeks, \(days) days"
    }

    private func scheduleNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()

        // Request permission for notifications
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                self.createNotification(for: "Ears", date: self.nextEarCleaningDate, notificationCenter: notificationCenter)
                self.createNotification(for: "Teeth", date: self.nextTeethCleaningDate, notificationCenter: notificationCenter)
                self.createNotification(for: "Paws", date: self.nextPawsCleaningDate, notificationCenter: notificationCenter)
                self.createNotification(for: "Bath", date: self.nextBathDate, notificationCenter: notificationCenter)
            }
        }
    }

    private func testNotificationGrooming() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                self.createTestNotification(notificationCenter: notificationCenter)
            }
        }
    }

    private func createTestNotification(notificationCenter: UNUserNotificationCenter) {
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is a test notification for the GroomingView."
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // Trigger after 5 seconds
        let request = UNNotificationRequest(identifier: "TestGroomingNotification", content: content, trigger: trigger)
        notificationCenter.add(request)
    }

    private func createNotification(for activity: String, date: Date, notificationCenter: UNUserNotificationCenter) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder: \(activity) Cleaning"
        content.body = "Upcoming \(activity.lowercased()) cleaning in a week!"
        content.sound = UNNotificationSound.default

        if let triggerDate = Calendar.current.date(byAdding: .day, value: -7, to: date) {
            let triggerComponents = Calendar.current.dateComponents([.year, .month, .day], from: triggerDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)

            let request = UNNotificationRequest(identifier: "\(activity)CleaningReminder", content: content, trigger: trigger)
            notificationCenter.add(request) { (error) in
                if let error = error {
                    // Handle any errors
                    print("Error scheduling notification: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension DateFormatter {
    static let groomingScheduleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

struct GroomingView_Previews: PreviewProvider {
    static var previews: some View {
        GroomingView()
    }
}
