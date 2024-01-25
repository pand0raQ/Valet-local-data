
import SwiftUI

struct GroomingCardView: View {
    @Binding var groomingActivity: GroomingActivity
    @State private var navigateGroomingView = false  // State for controlling navigation
    var onComplete: () -> Void


    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(groomingActivity.activityName)
                .font(.title)
                .fontWeight(.bold)

            Text("Frequency: Every \(groomingActivity.frequencyInWeeks) week\(groomingActivity.frequencyInWeeks > 1 ? "s" : "")")
                .font(.subheadline)

            if let lastCompletedDate = groomingActivity.lastCompletedDate {
                Text("Last Completed: \(lastCompletedDate, formatter: dateFormatter)")
                    .font(.subheadline)
            }

            if let nextDueDate = groomingActivity.nextDueDate {
                Text("Next Due: \(nextDueDate, formatter: dateFormatter)")
                    .font(.subheadline)
            }

            Button("Mark as Completed") {
                onComplete()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding()
    }

    private func markActivityAsCompleted() {
        groomingActivity.lastCompletedDate = Date()
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}



