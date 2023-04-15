public struct RoomEntity {
    /// ID
    public var id: Int

    /// ユーザー一覧
    public var userList: [UserEntity]

    /// カードパッケージ
    public var cardPackage: CardPackageEntity
    
    public init(id: Int, userList: [UserEntity], cardPackage: CardPackageEntity) {
        self.id = id
        self.userList = userList
        self.cardPackage = cardPackage
    }
}
