struct SelectedCard: Identifiable {
    /// ID
    var id: Int
    
    /// ユーザー
    var user: User
    
    /// カード
    var card: Card
    
    /// テーマカラー
    var themeColor: ThemeColor
}
