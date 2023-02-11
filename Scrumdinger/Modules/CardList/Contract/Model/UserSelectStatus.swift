struct UserSelectStatus: Identifiable {
    /// ID
    var id: String

    /// ユーザー
    var user: User

    /// テーマカラー
    var themeColor: CardPackage.ThemeColor

    /// 選択済みカード
    var selectedCard: CardPackage.Card?
}
