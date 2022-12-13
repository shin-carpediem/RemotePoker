protocol CardListPresentation {
    /// ユーザーを購読する
    func subscribeUser()
    
    /// ユーザーの購読を解除する
    func unsubscribeUser()
    
    /// カードを選択した
    /// - parameter card: カード
    func didSelectCard(card: Card)
    
    /// 選択済みカード一覧を公開するボタンがタップされた
    func didTapOpenSelectedCardListButton()
    
    /// 選択済みカード一覧をリセットするボタンがタップされた
    func didTapResetSelectedCardListButton()
    
    /// 設定ボタンがタップされた
    func didTapSettingButton()
}

protocol CardListUseCase {
    /// ユーザーを購読する
    func subscribeUser()
    
    /// ユーザーの購読を解除する
    func unsubscribeUser()
    
    /// 選択されたカードIDを更新する
    /// - parameter card: カード
    func updateSelectedCardId(card: Card)
    
    /// ルームを取得する
    func fetchRoom()
}

protocol CardListPresentationOutput {
    /// ヘッダータイトルを出力する
    func outputHeaderTitle()
    
    /// ユーザーの選択されたカード一覧状況を出力する
    func outputUserSelectStatus()
    
    /// データ処理の成功を出力
    func outputSuccess()
    
    /// エラーを出力
    func outputError()
}
