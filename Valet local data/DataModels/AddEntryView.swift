// AddEntryView.swift

import SwiftUI

struct AddEntryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataModel: DataModel
    @State private var title: String = ""
    @State private var details: String = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Details", text: $details)
                Button("Add Entry") {
                    dataModel.addEntry(title: title, details: details)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Add Entry")
        }
    }
}
