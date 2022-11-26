import FirebaseFirestore
import FirebaseFirestoreSwift

protocol RoomRepository {
    /// ルームを新規作成する
    /// - parameter room: ルーム
    func createRoom(_ room: Room) async
    
    /// ルームが存在するか確認する
    /// - parameter roomId: ルームID
    /// - returns: 存在するか
    func checkRoomExist(roomId: Int) async -> Bool
    
    /// ルームを取得する
    /// - returns: ルーム
    func fetchRoom() async -> Room
    
    /// ルームにユーザーを追加する
    /// - parameter user: ユーザー
    func addUserToRoom(user: User) async
    
    /// ルームから退出する
    /// - parameter userId: ユーザーID
    func removeUserFromRoom(userId: String) async
    
    /// ルームを削除する
    func deleteRoom() async
}
