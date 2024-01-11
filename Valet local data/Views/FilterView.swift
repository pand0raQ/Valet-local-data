// FilterView.swift

import SwiftUI

struct FilterView: View {
    @Binding var selectedCategories: Set<String>
    let categories: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Filter Categories")
                .font(.headline)
            ForEach(categories, id: \.self) { category in
                Button(action: {
                    if selectedCategories.contains(category) {
                        selectedCategories.remove(category)
                    } else {
                        selectedCategories.insert(category)
                    }
                }) {
                    HStack {
                        Text(category)
                        Spacer()
                        if selectedCategories.contains(category) {
                            Image(systemName: "checkmark")
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(selectedCategories: .constant(Set(["Category1", "Category2"])), categories: ["Category1", "Category2", "Category3"])
    }
}
