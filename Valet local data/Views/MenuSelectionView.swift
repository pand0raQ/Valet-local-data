
// MenuSelectionView.swift

import SwiftUI

struct MenuSelectionView: View {
    @Binding var selectedMenuItems: Set<String>
    let allMenuItems: [MenuItem]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Button(action: {
                withAnimation(.interpolatingSpring(stiffness: 50, damping: 5)) {
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Image(systemName: "button.horizontal.top.press.fill")
                    .font(.system(size: 48, weight: .ultraLight))
                    .foregroundColor(.accentColor)
                    .symbolRenderingMode(.hierarchical)
            }
            .padding()
            

            List(allMenuItems, id: \.id) { item in
                Button(action: {
                    if selectedMenuItems.contains(item.title) {
                        selectedMenuItems.remove(item.title)
                    } else {
                        selectedMenuItems.insert(item.title)
                    }
                }) {
                    HStack {
                        Text(item.title)
                        Spacer()
                        if selectedMenuItems.contains(item.title) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20, weight: .black))
                                .foregroundColor(.green)
                                .symbolRenderingMode(.hierarchical)
                        }
                    }
                }
            }
        }
        .navigationTitle("Select Items")
    }
}

struct MenuSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        MenuSelectionView(selectedMenuItems: .constant(Set()), allMenuItems: MenuDataModel.allMenuItems)
    }
}
