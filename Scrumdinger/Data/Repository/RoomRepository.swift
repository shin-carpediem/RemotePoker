import FirebaseFirestore
import FirebaseFirestoreSwift

protocol RoomDelegate {
    /// ユーザーが追加された時
    func whenUserAdded()
    
    /// ユーザーが更新された時
    func whenUserModified()
    
    /// ユーザーが削除された時
    func whenUserRemoved()
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
    
    /// カードを選択済みカード一覧に追加する
    /// - parameter userId: ユーザーID
    /// - parameter cardId: カードID
    func addCardToSelectedCardList(userId: String, cardId: String) async
    
    /// ユーザーの購読を解除する
    func unsubscribeUser()
}
