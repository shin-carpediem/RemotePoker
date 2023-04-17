public struct RoomViewModel {
    public var id: Int
    public var userList: [UserViewModel]
    public var cardPackage: CardPackageViewModel

    public init(id: Int, userList: [UserViewModel], cardPackage: CardPackageViewModel) {
        self.id = id
        self.userList = userList
        self.cardPackage = cardPackage
    }
}
