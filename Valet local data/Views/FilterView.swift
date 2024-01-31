import SwiftUI

struct FilterView: View {
        @Binding var selectedLogTypes: Set<LogType>

        var body: some View {
            Form {
                Toggle("Poop Log", isOn: binding(for: .poop))
                  Toggle("Vomit Log", isOn: binding(for: .vomit))
                  Toggle("DogAppetiteRecord", isOn: binding(for: .appetite))
                  Toggle("Allergies", isOn: binding(for: .allergies))
                  Toggle("Grooming", isOn: binding(for: .grooming))
                  Toggle("Medication", isOn: binding(for: .medication))

                
                
                // Add more log types if needed
            }
            .navigationBarTitle("Filter Logs")
        }

        private func binding(for logType: LogType) -> Binding<Bool> {
            return Binding<Bool>(
                get: { self.selectedLogTypes.contains(logType) },
                set: { set in
                    if set {
                        self.selectedLogTypes.insert(logType)
                    } else {
                        self.selectedLogTypes.remove(logType)
                    }
                }
            )
        }
    }
    
    
