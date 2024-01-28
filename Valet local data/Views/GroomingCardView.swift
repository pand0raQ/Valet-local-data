
import SwiftUI

struct GroomingCardView: View {
    @Binding var groomingActivity: GroomingActivity
    var onComplete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(groomingActivity.activityName)
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                if isDueInFiveDays {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.red)
                }
            }
            
            Text("Frequency: Every \(groomingActivity.frequencyInWeeks) week\(groomingActivity.frequencyInWeeks > 1 ? "s" : "")")
                .font(.subheadline)
            
            Text("Last Completed: \(lastCompletedText)")
                .font(.subheadline)
            
            if let nextDueDate = groomingActivity.nextDueDate {
                Text("Next Due: \(nextDueDate, formatter: dateFormatter)")
                    .font(.subheadline)
            }
            
            Button("Mark as Completed") {
                markActivityAsCompleted()
                onComplete()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding()
    }

    private var lastCompletedText: String {
        if let lastCompletedDate = groomingActivity.lastCompletedDate {
            return dateFormatter.string(from: lastCompletedDate)
        } else {
            return "-"
        }
    }

    private func markActivityAsCompleted() {
        groomingActivity.lastCompletedDate = Date()
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
// temporary 1 day
    private var isDueInFiveDays: Bool {
        if let dueDate = groomingActivity.nextDueDate {
            return Calendar.current.dateComponents([.day], from: Date(), to: dueDate).day ?? 0 <= 1
        }
        return false
    }
}

struct GroomingScheduleView: View {
    @ObservedObject var groomingViewModel: GroomingViewModel
    @State private var listID = UUID()


    var body: some View {
        NavigationView {
            List {
                ForEach(groomingViewModel.sortedGroomingActivities.indices, id: \.self) { index in
                            GroomingCardView(groomingActivity: $groomingViewModel.groomingActivities[index], onComplete: {
                                groomingViewModel.groomingActivities[index].markAsCompleted()
                            })
                }
            }
            .id(UUID())
            .navigationTitle("Grooming Schedule")
            .onAppear {
                listID = UUID() // Changes the ID to force a redraw

                           // Trigger sortedGroomingActivities computation.
                
                           let _ = groomingViewModel.sortedGroomingActivities
                       }
        }
    }
}
