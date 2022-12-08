protocol EnterRoomPresentation {
    /// 入力フォームが有効か
    func isInputFormValid() -> Bool
    
    /// ルームに入るボタンが押された
    /// - parameter userName: ユーザー名
    /// - parameter roomId: ルームID:
    func didTapEnterRoomButton(userName: String, roomId: Int) async
}

protocol EnterRoomPresentationOutput {
    /// 入力内容が無効だと示すアラートを出力する
    func outputInputInvalidAlert()
}
