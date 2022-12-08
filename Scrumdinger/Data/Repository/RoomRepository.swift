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
    
    /// カードをユーザーの選択済みカードに追加する
    /// - parameter userId: ユーザーID
    /// - parameter selectedCard: 選択されたカード
    func updateSelectedCard(userId: String, selectedCard: Card) async
    
    /// 全てのユーザーのカードを未選択状態にする
    func removeSelectedCardFromAllUsers() async
    
    /// ユーザーの購読を解除する
    func unsubscribeUser()
}
