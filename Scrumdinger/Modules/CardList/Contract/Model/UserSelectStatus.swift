struct UserSelectStatus: Identifiable {
    /// ID
    var id: String

    /// ユーザー
    var user: UserEntity

    /// テーマカラー
    var themeColor: CardPackageEntity.ThemeColor

    /// 選択済みカード
    var selectedCard: CardPackageEntity.Card?
}
