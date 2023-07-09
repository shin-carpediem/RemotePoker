import SwiftUI

public struct CardPackageViewModel: Identifiable {
    public var id: String
    public var themeColor: CardPackageThemeColor
    public var cardList: [Card]

    public struct Card: Identifiable {
        public var id: String
        public var estimatePoint: String
        public var index: Int
        public var fontColor: Color
        public var backgroundColor: Color

        public init(id: String, estimatePoint: String, index: Int, fontColor: Color, backgroundColor: Color)
        {
            self.id = id
            self.estimatePoint = estimatePoint
            self.index = index
            self.fontColor = fontColor
            self.backgroundColor = backgroundColor
        }
    }

    public init(id: String, themeColor: CardPackageThemeColor, cardList: [Card]) {
        self.id = id
        self.themeColor = themeColor
        self.cardList = cardList
    }
}

public enum CardPackageThemeColor: String, CaseIterable, ShapeStyle {
    case bubblegum
    case buttercup
    case indigo
    case lavender
    case magenta
    case navy
    case orange
    case oxblood
    case periwinkle
    case poppy
    case purple
    case seafoam
    case sky
    case tan
    case teal
    case yellow
}
