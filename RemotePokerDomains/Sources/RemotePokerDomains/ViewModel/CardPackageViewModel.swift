import SwiftUI

public struct CardPackageViewModel: Identifiable {
    /// ID
    public var id: String

    /// テーマカラー
    public var themeColor: CardPackageThemeColor

    /// カード一覧
    public var cardList: [Card]

    /// カード
    public struct Card: Identifiable {
        /// ID
        public var id: String

        /// 見積もりポイント
        public var point: String

        /// インデックス
        public var index: Int

        /// 文字色
        public var fontColor: Color

        /// 背景色
        public var backgroundColor: Color
        
        public init(id: String, point: String, index: Int, fontColor: Color, backgroundColor: Color) {
            self.id = id
            self.point = point
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
