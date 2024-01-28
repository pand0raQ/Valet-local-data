
import WidgetKit
import SwiftUI

struct PoopingDataWidgetView: View {
    @State private var poopingData = PoopingData()
  //  let justpooped = PoopingDataManager.shared.logCurrentPoopingData()
    
    let entry: PoopingDataProvider.Entry
  //  private func justPooped() {
   //     PoopingDataManager.shared.logCurrentPoopingData()
 //   }

    var body: some View {
        
        VStack {
            Text("Last💩 :")
                .font(.headline)
                .foregroundColor(.white)

            if let lastPoopedTime = entry.poopingData.lastPoopedDateTime {
                Text(" at: \(lastPoopedTime, formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.white)
            } else {
                Text("No pooping data available")
                    .font(.caption)
                    .foregroundColor(.white)
            }

           Button(intent: PoopIntent()) {
                Text("Just pooped")
.padding(.horizontal)
            }

            }
          
        .padding()
           .containerBackground(backgroundStyle(for: entry.poopingData), for: .widget)
           .cornerRadius(10)
       }

       private func backgroundStyle(for data: PoopingData) -> Color {
           return data.poopedInLast24Hours() ? Color.green : Color.red
       }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}



struct PoopingDataWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        PoopingDataWidgetView(entry: PoopingDataEntry(date: Date(), poopingData: PoopingData(lastPoopedDateTime: Date())))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

