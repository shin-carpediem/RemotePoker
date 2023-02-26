import SwiftUI

struct CardPackageViewModel: Identifiable {
    /// ID
    var id: String

    /// テーマカラー
    var themeColor: CardPackageThemeColor

    /// カード一覧
    var cardList: [Card]

    struct Card: Identifiable {
        /// ID
        var id: String

        /// 見積もりポイント
        var point: String

        /// インデックス
        var index: Int

        /// 文字色
        var fontColor: Color

        /// 背景色
        var backgroundColor: Color
    }
}

enum CardPackageThemeColor: String, CaseIterable, ShapeStyle {
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
