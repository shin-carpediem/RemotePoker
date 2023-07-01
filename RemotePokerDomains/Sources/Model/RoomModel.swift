public struct RoomModel {
    public var id: Int
    public var userList: [UserModel]
    public var cardPackage: CardPackageModel

    public init(id: Int, userList: [UserModel], cardPackage: CardPackageModel) {
        self.id = id
        self.userList = userList
        self.cardPackage = cardPackage
    }
}
