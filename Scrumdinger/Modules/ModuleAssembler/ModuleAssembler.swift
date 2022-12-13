protocol ModuleAssembler {
    /// ルームに入る画面をアセンブルする
    func assmebleEnterRoom() -> EnterRoomView
    
    /// カードリスト画面をアセンブルする
    /// - parameter room: ルーム
    /// - parameter currrentUser: カレントユーザー
    func assembleCardList(room: Room, currrentUser: User) -> CardListView
    
    /// 設定画面をアセンブルする
    /// - parameter room: ルーム
    /// - parameter currrentUser: カレントユーザー
    func assembleSetting(room: Room, currrentUser: User) -> SettingView
}
