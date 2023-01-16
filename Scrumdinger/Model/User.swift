struct User {
    /// ID
    var id: String

    /// 名前
    var name: String

    /// 入室中のルームID(未入室は0)
    var currentRoomId: Int

    /// 選択済みカードID(未選択は空文字)
    var selectedCardId: String
}
