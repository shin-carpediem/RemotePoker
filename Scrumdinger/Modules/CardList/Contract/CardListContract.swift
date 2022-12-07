protocol CardListPresentation {
    /// ヘッダーテキストを出力する
    func outputHeaderTitle() -> String
    
    /// ユーザーを購読する
    func subscribeUser()
    
    /// カードを選択した
    /// - parameter card: カード
    func didSelectCard(card: Card) async
    
    /// 選択済みカード一覧を公開する
    func openSelectedCardList()
    
    /// 選択済みカード一覧をリセットする
    func resetSelectedCardList() async
    
    /// ルームから退室する
    func leaveRoom() async
    
    /// ユーザーの購読を解除する
    func unsubscribeUser()
}
