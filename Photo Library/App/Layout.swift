import Foundation

enum Layout {
    static let stackViewSpacing: CGFloat = 15
    static let defaultOffset = 75
    static var halfOffset: Int { return defaultOffset / 2 }
    static var quaterOffset: Int { return defaultOffset / 4 }
    static var oneAndHalfOffset: Double { return Double(defaultOffset) * 1.5 }
    static var doubleOffset: Int { return defaultOffset * 2 }
    static let buttonHeightMultiplier = 0.25
    static let buttonsStackMultiplier = 0.06
}
