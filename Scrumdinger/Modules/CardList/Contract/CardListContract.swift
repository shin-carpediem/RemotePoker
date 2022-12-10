protocol CardListPresentation {
    /// ユーザーを購読する
    func subscribeUser()
    
    /// ユーザーの購読を解除する
    func unsubscribeUser()
    
    /// カードを選択した
    /// - parameter card: カード
    func didSelectCard(card: Card) async
    
    /// 選択済みカード一覧を公開するボタンがタップされた
    func didTapOpenSelectedCardListButton()
    
    /// 選択済みカード一覧をリセットするボタンがタップされた
    func didTapResetSelectedCardListButton() async
    
    /// ルームから退室するボタンがタップされた
    func didTapLeaveRoomButton() async
    
    /// 設定ボタンがタップされた
    func didTapSettingButton()
}
