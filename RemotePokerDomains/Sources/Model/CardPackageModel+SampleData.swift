import Foundation.NSUUID

/// サンプルデータ
extension CardPackageModel {
    public static let defaultCardPackage = CardPackageModel(
        id: UUID().uuidString,
        themeColor: "oxblood",
        cardList: defaultCardList)

    public static let defaultCardList = [
        Card(
            id: UUID().uuidString,
            estimatePoint: "0",
            index: 0),
        Card(
            id: UUID().uuidString,
            estimatePoint: "1",
            index: 1),
        Card(
            id: UUID().uuidString,
            estimatePoint: "2",
            index: 2),
        Card(
            id: UUID().uuidString,
            estimatePoint: "3",
            index: 3),
        Card(
            id: UUID().uuidString,
            estimatePoint: "5",
            index: 4),
        Card(
            id: UUID().uuidString,
            estimatePoint: "8",
            index: 5),
        Card(
            id: UUID().uuidString,
            estimatePoint: "13",
            index: 6),
        Card(
            id: UUID().uuidString,
            estimatePoint: "21",
            index: 7),
        Card(
            id: UUID().uuidString,
            estimatePoint: "34",
            index: 8),
        Card(
            id: UUID().uuidString,
            estimatePoint: "55",
            index: 9),
        Card(
            id: UUID().uuidString,
            estimatePoint: "?",
            index: 10),
        Card(
            id: UUID().uuidString,
            estimatePoint: "☕️",
            index: 11),
    ]
}
