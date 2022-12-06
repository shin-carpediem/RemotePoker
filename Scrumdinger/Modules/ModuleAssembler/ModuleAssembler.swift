protocol ModuleAssembler {
    /// ルームに入る画面をアセンブルする
    func assmebleEnterRoom() -> EnterRoomView
    
    /// カードリスト画面をアセンブルする
    /// - parameter room: ルーム
    /// - parameter currrentUser: カレントユーザー
    func assembleCardList(room: Room, currrentUser: User) -> CardListView
    
    /// ≈をアセンブルする
    /// - parameter selectedCardList: 選択されたカード一覧
    func assembleOpenCardList(selectedCardList: [SelectedCard]) -> OpenCardListView
}
