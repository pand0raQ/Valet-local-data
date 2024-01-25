
import WidgetKit
import SwiftUI

struct PoopingDataEntry: TimelineEntry {
    let date: Date
    let poopingData: PoopingData
}

struct PoopingDataProvider: TimelineProvider {
    // Initialize shared UserDefaults
    let sharedUserDefaults = UserDefaults(suiteName: "group.valet.local.data")

    func placeholder(in context: Context) -> PoopingDataEntry {
        PoopingDataEntry(date: Date(), poopingData: PoopingData())
    }

    func getSnapshot(in context: Context, completion: @escaping (PoopingDataEntry) -> ()) {
        let entry = PoopingDataEntry(date: Date(), poopingData: loadPoopingData())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PoopingDataEntry>) -> ()) {
        var entries: [PoopingDataEntry] = []

        // Fetch the current pooping data
        let currentData = loadPoopingData()

        // Generate a timeline entry for each minute in the next hour
        let currentDate = Date()
        for minuteOffset in 0..<60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = PoopingDataEntry(date: entryDate, poopingData: currentData)
            entries.append(entry)
        }

        // Calculate the next update time - 1 minute after the last entry
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 1, to: entries.last!.date)!

        // Construct a timeline with the entries
        let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
        completion(timeline)
    }

    private func loadPoopingData() -> PoopingData {
        if let savedData = sharedUserDefaults?.data(forKey: "PoopingData") {
            let decoder = JSONDecoder()
            if let loadedRecord = try? decoder.decode(PoopingData.self, from: savedData) {
                return loadedRecord
            } else {
                print("Failed to decode PoopingData")
            }
        } else {
            print("No PoopingData found in shared UserDefaults")
        }
        
        return PoopingData()
    }
}
