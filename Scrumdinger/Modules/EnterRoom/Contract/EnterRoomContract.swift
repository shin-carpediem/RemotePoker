protocol EnterRoomPresentation {
    /// 入力フォームが有効か
    func isInputFormValid() -> Bool
    
    /// 入力内容が無効だと示すアラートを表示する
    func showInputInvalidAlert()
    
    /// ルームに入る
    /// - parameter userName: ユーザー名
    /// - parameter roomId: ルームID:
    func enterRoom(userName: String, roomId: Int) async
}
