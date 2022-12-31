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

protocol RoomDelegate: AnyObject {
    /// ルームにユーザーが追加/更新/削除された時
    func whenUserChanged(actionType: UserActionType)
}

protocol RoomRepository {
    /// デリゲート
    var delegate: RoomDelegate? { get set }
    
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
    /// - parameter selectedCardDictionary: ユーザーIDと選択されたカードIDの辞書
    func updateSelectedCardId(selectedCardDictionary: [String: String])
    
    /// テーマカラーを変更する
    /// - parameter themeColor: テーマカラー
    func updateThemeColor(themeColor: ThemeColor)
}
