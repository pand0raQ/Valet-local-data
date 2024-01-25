////
////  poopingWidgetLiveActivity.swift
////  poopingWidget
////
////  Created by Анастасия Степаносова on 24.01.2024.
////
//
//import ActivityKit
//import WidgetKit
//import SwiftUI
//
//struct poopingWidgetAttributes: ActivityAttributes {
//    public struct ContentState: Codable, Hashable {
//        // Dynamic stateful properties about your activity go here!
//        var emoji: String
//    }
//
//    // Fixed non-changing properties about your activity go here!
//    var name: String
//}
//
//struct poopingWidgetLiveActivity: Widget {
//    var body: some WidgetConfiguration {
//        ActivityConfiguration(for: poopingWidgetAttributes.self) { context in
//            // Lock screen/banner UI goes here
//            VStack {
//                Text("Hello \(context.state.emoji)")
//            }
//            .activityBackgroundTint(Color.cyan)
//            .activitySystemActionForegroundColor(Color.black)
//
//        } dynamicIsland: { context in
//            DynamicIsland {
//                // Expanded UI goes here.  Compose the expanded UI through
//                // various regions, like leading/trailing/center/bottom
//                DynamicIslandExpandedRegion(.leading) {
//                    Text("Leading")
//                }
//                DynamicIslandExpandedRegion(.trailing) {
//                    Text("Trailing")
//                }
//                DynamicIslandExpandedRegion(.bottom) {
//                    Text("Bottom \(context.state.emoji)")
//                    // more content
//                }
//            } compactLeading: {
//                Text("L")
//            } compactTrailing: {
//                Text("T \(context.state.emoji)")
//            } minimal: {
//                Text(context.state.emoji)
//            }
//            .widgetURL(URL(string: "http://www.apple.com"))
//            .keylineTint(Color.red)
//        }
//    }
//}
//
//extension poopingWidgetAttributes {
//    fileprivate static var preview: poopingWidgetAttributes {
//        poopingWidgetAttributes(name: "World")
//    }
//}
//
//extension poopingWidgetAttributes.ContentState {
//    fileprivate static var smiley: poopingWidgetAttributes.ContentState {
//        poopingWidgetAttributes.ContentState(emoji: "😀")
//     }
//     
//     fileprivate static var starEyes: poopingWidgetAttributes.ContentState {
//         poopingWidgetAttributes.ContentState(emoji: "🤩")
//     }
//}
//
//#Preview("Notification", as: .content, using: poopingWidgetAttributes.preview) {
//   poopingWidgetLiveActivity()
//} contentStates: {
//    poopingWidgetAttributes.ContentState.smiley
//    poopingWidgetAttributes.ContentState.starEyes
//}
