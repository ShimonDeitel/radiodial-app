import SwiftUI

enum Theme {
    static let accent = Color(red: 0.9569, green: 0.6353, blue: 0.3804)
    static let background = Color(red: 0.0902, green: 0.0627, blue: 0.0353)
    static let card = Color(red: 0.1451, green: 0.1059, blue: 0.0627)
    static let textPrimary = Color(red: 0.9843, green: 0.9333, blue: 0.8745)
    static let textMuted = Color(red: 0.8471, green: 0.7176, blue: 0.5569)

    static let titleFont = Font.system(.title2, design: .serif).weight(.bold)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let labelFont = Font.system(.caption, design: .rounded).weight(.semibold)
}
