protocol ModuleAssembler {
    /// ルームに入る画面をアセンブルする
    /// - returns: ルームに入る画面
    func assmebleEnterRoom() -> EnterRoomView
    
    /// カードリスト画面をアセンブルする
    /// - parameter room: ルーム
    /// - parameter currrentUser: カレントユーザー
    /// - returns: カードリスト画面
    func assembleCardList(room: Room, currrentUser: User) -> CardListView
    
    /// 公開されたカード一覧画面をアセンブルする
    func assembleOpenCardList() -> OpenCardListView
}
