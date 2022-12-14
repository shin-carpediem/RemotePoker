protocol EnterRoomPresentation {
    /// カレントユーザーのローカルデータを取得する
    func fetchCurrentUserLocalData()
        
    /// 入力フォームが有効か
    func isInputFormValid() -> Bool
    
    /// ログイン済みのルームに入るボタンが押された
    func didTapEnterExistingRoomButton()
    
    /// ルームに入るボタンが押された
    /// - parameter userName: ユーザー名
    /// - parameter roomId: ルームID:
    func didTapEnterRoomButton(userName: String,
                               roomId: Int)
}

protocol EnterRoomPresentationOutput {
    /// ログイン済みのルームに入るか促すアラートを出力する
    func outputLoginAsCurrentUserAlert()
    
    /// 入力内容が無効だと示すアラートを出力する
    func outputInputInvalidAlert()
}
