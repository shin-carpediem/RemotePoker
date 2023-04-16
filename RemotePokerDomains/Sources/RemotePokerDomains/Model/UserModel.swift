public struct UserModel {
    /// ID
    public var id: String

    /// 名前
    public var name: String

    /// 入室中のルームID(未入室は0)
    public var currentRoomId: Int

    /// 選択済みカードID(未選択は空文字)
    public var selectedCardId: String
    
    public init(id: String, name: String, currentRoomId: Int, selectedCardId: String) {
        self.id = id
        self.name = name
        self.currentRoomId = currentRoomId
        self.selectedCardId = selectedCardId
    }
}
