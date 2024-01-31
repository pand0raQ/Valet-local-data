//import WidgetKit
//import SwiftUI
//
//struct PoopingDataWidget: Widget {
//    let kind: String = "PoopingDataWidget"
//
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: PoopingDataProvider()) { entry in
//            PoopingDataWidgetView(entry: entry)
//        }
//        .configurationDisplayName("Dog Pooping Tracker")
//        .description("Tracks when your dog last pooped and indicates if it's been in the last 24 hours.")
//        .supportedFamilies([.systemSmall, .systemMedium]) // You can add more sizes if needed
//    }
//}
//
//@main
//struct PoopingDataWidgetBundle: WidgetBundle {
//    @WidgetBundleBuilder
//    var body: some Widget {
//        PoopingDataWidget()
//    }
//}
//
