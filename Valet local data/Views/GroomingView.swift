
import SwiftUI


struct GroomingView: View {
    @ObservedObject var groomingViewModel: GroomingViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(groomingViewModel.groomingActivities.indices, id: \.self) { index in
                    VStack(alignment: .leading) {
                        Text(groomingViewModel.groomingActivities[index].activityName)
                            .font(.headline)
                        HStack {
                            Text("Every \(groomingViewModel.groomingActivities[index].frequencyInWeeks) week\(groomingViewModel.groomingActivities[index].frequencyInWeeks > 1 ? "s" : "")")
                            Spacer()
                            Picker("Frequency", selection: $groomingViewModel.groomingActivities[index].frequencyInWeeks) {
                                ForEach(1...12, id: \.self) { week in
                                    Text("\(week) week\(week > 1 ? "s" : "")").tag(week)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        if let nextDueDate = groomingViewModel.groomingActivities[index].nextDueDate {
                            Text("Next Due: \(nextDueDate, formatter: dateFormatter)")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Grooming Schedule")
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}


