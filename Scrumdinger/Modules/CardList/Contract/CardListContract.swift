protocol CardListPresentation {
    /// View初期読み込み時
    func viewDidLoad()
    
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
    /// カードパッケージを購読する
    func subscribeCardPackages()
    
    /// カードバッケージの購読を解除する
    func unsubscribeCardPackages()
    
    /// ユーザーを購読する
    func subscribeUsers()
    
    /// ユーザーの購読を解除する
    func unsubscribeUsers()
    
    /// 選択されたカードIDを更新する
    /// - parameter selectedCardDictionary: カレントユーザーIDと選択されたカードIDの辞書
    func updateSelectedCardId(selectedCardDictionary: [String: String])
    
    /// ルームを取得する
    func fetchRoom() async
}

protocol CardListPresentationOutput {
    /// ルームを出力する
    /// - parameter room: ルーム
    func outputRoom(_ room: Room)
    
    /// テーマカラーを出力する
    func outputThemeColor()
    
    /// ヘッダータイトルを出力する
    func outputHeaderTitle()
    
    /// ユーザーの選択されたカード一覧状況を出力する
    func outputUserSelectStatus()
    
    /// データ処理の成功を出力
    func outputSuccess()
    
    /// エラーを出力
    func outputError()
}
