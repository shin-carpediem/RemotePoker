/// サンプルデータ
extension CardPackageModel {
    public static let defaultCardPackage = CardPackageModel(
        id: 0,
        themeColor: "oxblood",
        cardList: defaultCardList)

    public static let defaultCardList = [
        Card(
            id: 0,
            estimatePoint: "0",
            index: 0),
        Card(
            id: 1,
            estimatePoint: "1",
            index: 1),
        Card(
            id: 2,
            estimatePoint: "2",
            index: 2),
        Card(
            id: 3,
            estimatePoint: "3",
            index: 3),
        Card(
            id: 4,
            estimatePoint: "5",
            index: 4),
        Card(
            id: 5,
            estimatePoint: "8",
            index: 5),
        Card(
            id: 6,
            estimatePoint: "13",
            index: 6),
        Card(
            id: 7,
            estimatePoint: "21",
            index: 7),
        Card(
            id: 8,
            estimatePoint: "34",
            index: 8),
        Card(
            id: 9,
            estimatePoint: "55",
            index: 9),
        Card(
            id: 10,
            estimatePoint: "?",
            index: 10),
        Card(
            id: 11,
            estimatePoint: "☕️",
            index: 11),
    ]
}
