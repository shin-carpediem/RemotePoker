struct UserSelectStatusViewModel: Identifiable {
    /// ID
    var id: String

    /// ユーザー
    var user: UserViewModel

    /// テーマカラー
    var themeColor: CardPackageThemeColor

    /// 選択済みカード
    var selectedCard: CardPackageViewModel.Card?
}
