public struct RoomEntity {
    public var id: Int

    public var userList: [UserEntity]

    public var cardPackage: CardPackageEntity

    public init(id: Int, userList: [UserEntity], cardPackage: CardPackageEntity) {
        self.id = id
        self.userList = userList
        self.cardPackage = cardPackage
    }
}
