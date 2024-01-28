


import Foundation
import AppIntents
import SwiftUI

struct PoopIntent: AppIntent {
    private func justPooped() {
          PoopingDataManager.shared.logCurrentPoopingData()
      }
    
    static var title: LocalizedStringResource = "Test Title"
    static var description  = IntentDescription("test description ")

    func perform() async throws -> some IntentResult {
        print("the w was taped")
        justPooped()
        return .result()
    }
    
    
}

