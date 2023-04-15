public protocol EnterRoomRepository: AnyObject {
    /// ルームが存在するか確認する
    /// - parameter roomId: ルームID
    /// - returns: 存在するか
    func checkRoomExist(roomId: Int) async -> Bool

    /// ルームを新規作成する
    /// - parameter room: ルーム
    func createRoom(_ room: RoomEntity) async -> Result<Void, FirebaseError>
}
