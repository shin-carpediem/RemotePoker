protocol CardListPresentation {
    /// ルームを購読する
    func subscribeRoom()
    
    /// 選択済みカード一覧を公開する
    func openSelectedCardList()
    
    /// 選択済みカード一覧をリセットする
    func resetSelectedCardList()
    
    /// ルームから退室する
    func leaveRoom() async
}
