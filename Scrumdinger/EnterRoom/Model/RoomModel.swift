struct RoomModel: Identifiable {
    /// ID
    var id: String
    
    /// ユーザーID一覧
    var userIdList: [String]

    /// カード一覧
    private(set) var cardList = [CardListModel.sampleData]
}

extension RoomModel {
    static let sampleData = RoomModel(id: "0",
                                      userIdList: ["0"])
}
