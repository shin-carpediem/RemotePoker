public struct RoomEntity {
    public var id: Int
    public var userIdList: [String]
    public var cardPackage: CardPackageEntity

    public init(id: Int, userIdList: [String], cardPackage: CardPackageEntity) {
        self.id = id
        self.userIdList = userIdList
        self.cardPackage = cardPackage
    }
}
