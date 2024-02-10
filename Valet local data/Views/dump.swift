//
//
//struct CalendarView: View {
//    @State private var selectedDate = Date()
//    @State private var showingSheet = false
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 0) {
//                CustomCalendar(
//                    selectedDate: $selectedDate,
//                    showingSheet: $showingSheet,
//                    getLogTypes: { _ in [] } // Replace this with your actual function
//                )
//                .onChange(of: selectedDate) { newDate in
//                    // Update your state variables here
//                }
//                .edgesIgnoringSafeArea(.all)
//            }
//            .sheet(isPresented: $showingSheet) {
//                // Your sheet content goes here
//                Text("Details for \(selectedDate)") // Placeholder for your actual sheet content
//            }
//        }
//        .onAppear {
//            // Call your data loading function here
//        }
//        .edgesIgnoringSafeArea(.top)
//    }
//}
//
//struct CustomCalendar: View {
//    @Binding var selectedDate: Date
//    @Binding var showingSheet: Bool
//    let calendar = Calendar.current
//    var getLogTypes: (Date) -> [DogLog]
//
//    var body: some View {
//        VStack {
//            HStack {
//                Button(action: { self.moveMonth(by: -1) }) {
//                    Image(systemName: "chevron.left")
//                }
//                Spacer()
//                Text("\(monthYearText(from: selectedDate))")
//                    .font(.headline)
//                Spacer()
//                Button(action: { self.moveMonth(by: 1) }) {
//                    Image(systemName: "chevron.right")
//                }
//            }
//            .padding()
//
//            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7), spacing: 0) {
//                ForEach(daysInMonth(for: selectedDate), id: \.self) { date in
//                    calendarCell(for: date)
//                }
//            }
//        }
//    }
//
//    @ViewBuilder
//    private func calendarCell(for date: Date) -> some View {
//        VStack {
//            Text("\(date, formatter: dayFormatter)")
//                .frame(maxWidth: .infinity)
//                .padding(.bottom, 5)
//            logTypeView(for: date)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Calendar.current.isDate(date, inSameDayAs: selectedDate) ? Color.blue : Color.clear)
//        .cornerRadius(8)
//        .onTapGesture {
//            self.selectedDate = date
//            self.showingSheet = true
//        }
//        .padding(.horizontal)
//    }
//
//    @ViewBuilder
//    private func logTypeView(for date: Date) -> some View {
//        ForEach(getLogTypes(for: date), id: \.self) { log in
//            if log.type == .poop && log.isDetailed {
//                Text("❌ 💩")
//            } else {
//                Text(log.type.emoji)
//            }
//        }
//    }
//
//    func monthYearText(from date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMMM yyyy"
//        return formatter.string(from: date)
//    }
//
//    func daysInMonth(for date: Date) -> [Date] {
//        guard let range = calendar.range(of: .day, in: .month, for: date) else { return [] }
//        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
//
//        return range.compactMap { day -> Date? in
//            return calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
//        }
//    }
//
//    func moveMonth(by months: Int) {
//        if let newMonth = calendar.date(byAdding: .month, value: months, to: selectedDate) {
//            selectedDate = newMonth
//        }
//    }
//
//    var dayFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "d"
//        return formatter
//    }
//}
//
//

