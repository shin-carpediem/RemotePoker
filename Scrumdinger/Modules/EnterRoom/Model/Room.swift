struct Room: Identifiable {
    /// ID
    var id: Int
    
    /// ユーザーID一覧
    var userIdList: [String]

    /// カードパッケージ
    var cardPackage: CardPackage
}
