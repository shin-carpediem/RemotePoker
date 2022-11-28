protocol CardListPresentation {
    /// ヘッダーテキストを出力する
    func outputHeaderTitle()
    
    /// ユーザーを購読する
    func subscribeUser()
    
    /// 選択済みカード一覧を公開する
    func openSelectedCardList()
    
    /// 選択済みカード一覧をリセットする
    func resetSelectedCardList()
    
    /// ルームから退室する
    func leaveRoom() async
    
    /// ユーザーの購読を解除する
    func unsubscribeUser()
}
