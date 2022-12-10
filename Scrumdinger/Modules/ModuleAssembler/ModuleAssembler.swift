protocol ModuleAssembler {
    /// ルームに入る画面をアセンブルする
    func assmebleEnterRoom() -> EnterRoomView
    
    /// カードリスト画面をアセンブルする
    /// - parameter room: ルーム
    /// - parameter currrentUser: カレントユーザー
    func assembleCardList(room: Room, currrentUser: User) -> CardListView
    
    /// 選択されたカード一覧画面をアセンブルする
    /// - parameter room: ルーム
    /// - parameter userSelectStatus: ユーザーのカード選択状況
    func assembleOpenCardList(room: Room, userSelectStatus: [UserSelectStatus]) -> OpenCardListView
    
    /// 設定画面をアセンブルする
    func assembleSetting() -> SettingView
}
