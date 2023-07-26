public struct RoomModel {
    public var id: Int
    public var userIdList: [String]
    public var cardPackage: CardPackageModel

    public init(id: Int, userIdList: [String], cardPackage: CardPackageModel) {
        self.id = id
        self.userIdList = userIdList
        self.cardPackage = cardPackage
    }
}
