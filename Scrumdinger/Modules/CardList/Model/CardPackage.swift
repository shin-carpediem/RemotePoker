import SwiftUI

struct CardPackage: Identifiable {
    /// ID
    var id: String = UUID().uuidString
    
    /// テーマカラー
    var themeColor: ThemeColor
    
    /// カード一覧
    var cardList: [Card]
}

struct Card: Identifiable {
    /// ID
    var id: String = UUID().uuidString

    /// 見積もりポイント
    var point: String

    /// インデックス
    var index: Int

    /// 文字色
    var fontColor: Color {
        let number = index >= 10 ? 9 : index
        let opacity = Double("0.\(number)") ?? 1.0
        return opacity >= 0.5 ? .white : .gray
    }

    /// 指定カードの背景色
    func outputBackgroundColor(color: ThemeColor) -> Color {
        let number = index >= 10 ? 9 : index
        let opacity = Double("0.\(number)") ?? 1.0
        return Color(color.rawValue).opacity(opacity)
    }
}

enum ThemeColor: String {
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

/// サンプルデータ
extension CardPackage {
    static let sampleCardPackage = CardPackage(themeColor: .purple,
                                               cardList: sampleCardList)
    
    static let sampleCardList = [Card(point: "0", index: 0),
                                 Card(point: "1", index: 1),
                                 Card(point: "2", index: 2),
                                 Card(point: "3", index: 3),
                                 Card(point: "5", index: 4),
                                 Card(point: "8", index: 5),
                                 Card(point: "13", index: 6),
                                 Card(point: "21", index: 7),
                                 Card(point: "34", index: 8),
                                 Card(point: "☕️", index: 9)]
}