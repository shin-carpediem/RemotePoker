protocol EnterRoomPresentation {
    /// ルームに入る
    /// - parameter userName: ユーザー名
    /// - parameter roomId: ルームID:
    func enterRoom(userName: String, roomId: Int) async
}
