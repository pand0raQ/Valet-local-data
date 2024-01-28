import Foundation
import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            Button(action: { self.selectedTab = 0 }) {
                Image(systemName: "house.fill") // Icon for Dashboard
            }
            Spacer()
            Button(action: { self.selectedTab = 1 }) {
                Image(systemName: "calendar") // Icon for Calendar
            }
            Spacer()
            Button(action: { self.selectedTab = 2 }) {
                Image(systemName: "person.fill") // Icon for Profile
            }
        }
        .padding()
        .background(CurvedShape()) // Custom shape for the fan effect
    }
}

// Custom shape for the tab bar
struct CurvedShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Create a custom fan, thick in the middle and rounded on edges shape
        // This is a placeholder, you'll need to design the shape as per your requirement
        path.move(to: CGPoint(x: 0, y: 0))
        // Add custom curve drawing code here
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

