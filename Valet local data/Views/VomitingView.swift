import SwiftUI

struct VomitingView: View {
    @State private var vomitDateTime = Date()
    @State private var showingImagePicker = false
    @State private var sourceType: ImagePicker.SourceType = .photoLibrary
    @State private var inputImage: UIImage?
    @State private var displayImage: Image?
    @State private var showingSaveAlert = false
    @State private var saveAlertMessage = ""

    var body: some View {
        ScrollView {
            VStack {
                DatePicker("Vomit Time", selection: $vomitDateTime, displayedComponents: [.date, .hourAndMinute])
                    .padding()

                if let displayImage = displayImage {
                    displayImage
                        .resizable()
                        .scaledToFit()
                } else {
                    HStack {
                        Button("Take Picture") {
                            self.sourceType = .camera
                            self.showingImagePicker = true
                        }
                        .padding()

                        Button("Select Picture") {
                            self.sourceType = .photoLibrary
                            self.showingImagePicker = true
                        }
                        .padding()
                    }
                }

                Button("Save") {
                    saveData()
                }
                .padding()

                // Display the saved data
                if let savedDate = UserDefaults.standard.string(forKey: "vomitDate"),
                   let savedImageData = UserDefaults.standard.data(forKey: "vomitImageData"),
                   let uiImage = UIImage(data: savedImageData) {
                    Text("Last Saved: \(savedDate)")
                        .padding()
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(sourceType: self.sourceType, image: self.$inputImage)
        }
        .alert(isPresented: $showingSaveAlert) {
            Alert(title: Text("Save Status"), message: Text(saveAlertMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func saveData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: vomitDateTime)
        
        if let imageData = inputImage?.jpegData(compressionQuality: 1.0) {
            UserDefaults.standard.set(imageData, forKey: "vomitImageData")
        }
        
        UserDefaults.standard.set(dateString, forKey: "vomitDate")

        saveAlertMessage = "Data saved successfully!"
        showingSaveAlert = true
    }

    private func loadImage() {
        guard let inputImage = inputImage else { return }
        displayImage = Image(uiImage: inputImage)
    }
}

struct VomitingView_Previews: PreviewProvider {
    static var previews: some View {
        VomitingView()
    }
}
