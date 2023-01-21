import SwiftUI

struct CardPackage: Identifiable {
    /// ID
    var id: String

    /// テーマカラー
    var themeColor: ThemeColor

    /// カード一覧
    var cardList: [Card]
}

struct Card: Identifiable {
    /// ID
    var id: String

    /// 見積もりポイント
    var point: String

    /// インデックス
    var index: Int

    /// 文字色
    var fontColor: Color {
        let number = index >= 10 ? 9 : index
        let opacity = Double("0.\(number)") ?? 1.0
        return opacity >= 0.4 ? .white : .gray
    }

    /// 指定カードの背景色
    func outputBackgroundColor(color: ThemeColor) -> Color {
        let number = index >= 10 ? 9 : index
        let opacity = Double("0.\(number)5") ?? 1.0
        return Color(color.rawValue).opacity(opacity)
    }
}

/// テーマカラー
enum ThemeColor: String, CaseIterable, ShapeStyle {
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
    static let defaultCardPackage = CardPackage(
        id: UUID().uuidString,
        themeColor: .oxblood,
        cardList: defaultCardList)

    static let defaultCardList = [
        Card(
            id: UUID().uuidString,
            point: "0",
            index: 0),
        Card(
            id: UUID().uuidString,
            point: "1",
            index: 1),
        Card(
            id: UUID().uuidString,
            point: "2",
            index: 2),
        Card(
            id: UUID().uuidString,
            point: "3",
            index: 3),
        Card(
            id: UUID().uuidString,
            point: "5",
            index: 4),
        Card(
            id: UUID().uuidString,
            point: "8",
            index: 5),
        Card(
            id: UUID().uuidString,
            point: "13",
            index: 6),
        Card(
            id: UUID().uuidString,
            point: "21",
            index: 7),
        Card(
            id: UUID().uuidString,
            point: "34",
            index: 8),
        Card(
            id: UUID().uuidString,
            point: "55",
            index: 9),
        Card(
            id: UUID().uuidString,
            point: "?",
            index: 10),
        Card(
            id: UUID().uuidString,
            point: "☕️",
            index: 11),
    ]
}
