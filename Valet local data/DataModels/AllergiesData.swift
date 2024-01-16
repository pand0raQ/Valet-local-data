

import Foundation


struct RashData: Codable, Identifiable {
    var id = UUID()
    var dater: Date
    var imageData: Data?
}

struct ScratchingIntensityEntry: Codable, Identifiable {
    var id = UUID()
    var intensity: String
    var datescr: Date

}

struct EyesData: Codable, Identifiable {
    var id = UUID()
    var dateeye: Date
    var intensity: String
    var imageData: Data?
}


