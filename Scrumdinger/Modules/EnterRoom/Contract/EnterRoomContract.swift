protocol EnterRoomPresentation {
    /// ルーム情報を確認、取得する
    /// - parameter inputName: 入力したユーザーの名前
    /// - parameter inputRoomId: 入力したルームID:
    func fetchRoomInfo(inputName: String, inputRoomId: Int) async
}
