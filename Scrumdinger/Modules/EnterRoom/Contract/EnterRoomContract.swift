protocol EnterRoomPresentation {
    /// 入力フォームが有効か
    func isInputFormValid() -> Bool
    
    /// ログイン済みのルームに入るボタンが押された
    func didTapEnterExistingRoomButton() async
    
    /// ルームに入るボタンが押された
    /// - parameter userName: ユーザー名
    /// - parameter roomId: ルームID:
    func didTapEnterRoomButton(userName: String, roomId: Int) async
}

protocol EnterRoomPresentationOutput {
    /// ログイン済みのルームに入るか促すアラートを出力する
    func outputLoginAsCurrentUserAlert()
    
    /// 入力内容が無効だと示すアラートを出力する
    func outputInputInvalidAlert()
}
