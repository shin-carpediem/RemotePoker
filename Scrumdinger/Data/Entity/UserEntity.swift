struct UserEntity {
    /// ID
    var id: String

    /// 名前
    var name: String

    /// 入室中のルームID(未入室は0)
    var currentRoomId: Int

    /// 選択済みカードID(未選択は空文字)
    var selectedCardId: String
}

struct UserSelectStatus: Identifiable {
    /// ID
    var id: String

    /// ユーザー
    var user: UserEntity

    /// テーマカラー
    var themeColor: ThemeColor

    /// 選択済みカード
    var selectedCard: Card?
}
