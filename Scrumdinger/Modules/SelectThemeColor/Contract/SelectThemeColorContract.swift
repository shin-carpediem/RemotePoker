protocol SelectThemeColorPresentation {
    /// View初期読み込み時
    func viewDidLoad()
    
    /// カラーをタップした
    /// - parameter themeColor: 選択したカラー
    func didTapColor(themeColor: ThemeColor)
}

protocol SelectThemeColorPresentationOutput {
    /// カラー一覧を出力する
    func outputColorList()
}
