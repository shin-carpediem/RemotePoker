public struct UserEntity {
    public var id: String
    public var name: String
    public var selectedCardId: Int?

    public init(id: String, name: String, selectedCardId: Int?) {
        self.id = id
        self.name = name
        self.selectedCardId = selectedCardId
    }
}
