public protocol EnterRoomRepository: AnyObject {
    /// ユーザーを新規作成する
    /// - parameter user: ユーザー
    func createUser(_ user: UserEntity) async -> Result<Void, FirebaseError>
    
    /// ルームが存在するか確認する
    /// - parameter roomId: ルームID
    /// - returns: 存在するか
    func checkRoomExist(roomId: String) async -> Bool

    /// ルームを新規作成する
    /// - parameter room: ルーム
    func createRoom(_ room: RoomEntity) async -> Result<Void, FirebaseError>
}
