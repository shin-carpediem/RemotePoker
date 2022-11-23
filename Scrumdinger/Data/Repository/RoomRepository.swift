import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

protocol RoomRepository {
    /// ルームを新規作成する
    /// - parameter roomModel: ルーム
    func createRoom(_ room: Room) async
    
    /// ルームが存在するか確認する
    /// - parameter roomId: ルームID
    /// - returns: 存在するか
    func checkRoomExist(roomId: String) async -> Bool
    
    /// ルーム情報を取得する
    /// - parameter roomId: ルームID
    /// - returns: ルーム
    func fetchRoom(roomId: String) async -> Room?
    
    /// ルームにユーザーを追加する
    /// - parameter roomId: ルームID
    /// - parameter userId: ユーザーID
    func addUserToRoom(roomId: String, userId: String) async
    
    /// ルームから退出する
    /// - parameter roomId: ルームID
    /// - parameter userId: ユーザーID
    func removeUserFromRoom(roomId: String, userId: String) async
    
    /// ルームを削除する
    /// - parameter roomId: ルームID
    func deleteRoom(roomId: String) async
}
