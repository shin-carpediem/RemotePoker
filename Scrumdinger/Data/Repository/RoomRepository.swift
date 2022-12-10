import FirebaseFirestore
import FirebaseFirestoreSwift

enum UserActionType {
    /// ユーザーが追加された時
    case added
    /// ユーザーが更新された時
    case modified
    /// ユーザーが削除された時
    case removed
    /// 不明
    case unKnown
}

protocol RoomDelegate {
    /// ユーザーが変更された時
    func whenUserChanged(actionType: UserActionType)
}

protocol RoomRepository {
    /// ルームが存在するか確認する
    /// - parameter roomId: ルームID
    /// - returns: 存在するか
    func checkRoomExist(roomId: Int) async -> Bool
    
    /// ルームを新規作成する
    /// - parameter room: ルーム
    func createRoom(_ room: Room) async
        
    /// ルームを取得する
    /// - returns: ルーム
    func fetchRoom() async -> Room
    
    /// ルームにユーザーを追加する
    /// - parameter user: ユーザー
    func addUserToRoom(user: User) async
    
    /// ルームから退出する
    /// - parameter userId: ユーザーID
    func removeUserFromRoom(userId: String) async
    
//    /// ルームを削除する
//    func deleteRoom() async
    
    /// ユーザーを購読する
    func subscribeUser()
    
    /// ユーザーの購読を解除する
    func unsubscribeUser()
    
    /// 指定IDのユーザーを取得する
    /// - parameter id: ユーザーID
    /// - returns: ユーザー
    func fetchUser(id: String) -> User
    
    /// ユーザーの選択済みカードを更新する
    /// - parameter userId: ユーザーID
    /// - parameter selectedCardId: 選択されたカードID
    func updateSelectedCardId(userId: String, selectedCardId: String) async
    
    /// 指定IDのカードを取得する
    /// - parameter cardPackageId: カードパッケージID
    /// - parameter cardId: カードID
    /// - returns: カード
    func fetchCard(cardPackageId: String, cardId: String) -> Card
}
