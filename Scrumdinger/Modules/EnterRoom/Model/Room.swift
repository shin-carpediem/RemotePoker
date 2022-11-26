struct Room {
    /// ID
    var id: Int
    
    /// ユーザー一覧
    var userList: [User]

    /// カードパッケージ
    var cardPackage: CardPackage
}

struct User {
    /// ID
    var id: String
    
    /// 名前
    var name: String
}
