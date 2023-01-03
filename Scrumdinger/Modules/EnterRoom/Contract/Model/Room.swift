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
    
    /// 入室中のルームID(未入室は0)
    var currentRoomId: Int
    
    /// 選択済みカードID(未選択は空文字)
    var selectedCardId: String
}

enum EnterRoomAction {
    /// 入室中のルームに入る
    case enterCurrentRoom
    
    /// 入室中ではない既存ルームに入る
    case enterOtherExistingRoom
    
    /// 新規ルームに入る
    case enterNewRoom
}
