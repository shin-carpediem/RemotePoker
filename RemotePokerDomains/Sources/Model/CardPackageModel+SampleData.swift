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
