protocol CardListPresentation: Presentation {
    /// カードを選択した
    /// - parameter cardId: カードID
    func didSelectCard(cardId: String)
    
    /// 選択済みカード一覧を公開するボタンがタップされた
    func didTapOpenSelectedCardListButton()
    
    /// 選択済みカード一覧をリセットするボタンがタップされた
    func didTapResetSelectedCardListButton()
    
    /// 設定ボタンがタップされた
    func didTapSettingButton()
}

protocol CardListUseCase: AnyObject {
    /// 購読に際しデリゲートを使えるようにする
    func activateRoomDelegate(_ self: CardListPresenter)
    
    /// ユーザーを購読する
    func subscribeUsers()
    
    /// ユーザーの購読を解除する
    func unsubscribeUsers()
    
    /// カードパッケージを購読する
    func subscribeCardPackages()
    
    /// カードバッケージの購読を解除する
    func unsubscribeCardPackages()
    
    /// 選択されたカードIDを更新する
    /// - parameter selectedCardDictionary: カレントユーザーIDと選択されたカードIDの辞書
    func updateSelectedCardId(selectedCardDictionary: [String: String])
    
    /// ルームを要求する
    func requestRoom() async
}

protocol CardListInteractorOutput: AnyObject {
    /// ルームを出力する
    @MainActor func outputRoom(_ room: Room)
    
    /// データ処理の成功を出力
    @MainActor func outputSuccess(message: String)
    
    /// エラーを出力
    @MainActor func outputError(_ error: Error, message: String)
}
