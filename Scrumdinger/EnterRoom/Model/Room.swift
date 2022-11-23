struct Room: Identifiable {
    /// ID
    var id: String
    
    /// ユーザーID一覧
    var userIdList: [String]

    /// カードパッケージ
    var cardPackage: CardPackage
}
