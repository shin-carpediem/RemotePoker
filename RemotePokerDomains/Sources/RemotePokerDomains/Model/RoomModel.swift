public struct RoomModel {
    /// ID
    public var id: Int

    /// ユーザー一覧
    public var userList: [UserModel]

    /// カードパッケージ
    public var cardPackage: CardPackageModel

    public init(id: Int, userList: [UserModel], cardPackage: CardPackageModel) {
        self.id = id
        self.userList = userList
        self.cardPackage = cardPackage
    }
}
