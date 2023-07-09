public struct UserViewModel {
    public var id: String
    public var name: String
    /// 選択済みカードID(未選択は空文字)
    public var selectedCardId: String

    public init(id: String, name: String, selectedCardId: String) {
        self.id = id
        self.name = name
        self.selectedCardId = selectedCardId
    }
}
