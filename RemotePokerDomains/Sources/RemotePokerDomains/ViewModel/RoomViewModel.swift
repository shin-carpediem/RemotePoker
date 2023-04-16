public struct RoomViewModel {
    /// ID
    public var id: Int

    /// ユーザー一覧
    public var userList: [UserViewModel]

    /// カードパッケージ
    public var cardPackage: CardPackageViewModel
    
    public init(id: Int, userList: [UserViewModel], cardPackage: CardPackageViewModel) {
        self.id = id
        self.userList = userList
        self.cardPackage = cardPackage
    }
}
