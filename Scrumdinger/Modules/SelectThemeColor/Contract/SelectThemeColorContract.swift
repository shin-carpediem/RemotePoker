protocol SelectThemeColorPresentation {
    /// View初期読み込み時
    func viewDidLoad()
    
    /// カラーをタップした
    /// - parameter color: 選択したカラー
    func didTapColor(color: ThemeColor)
}

protocol SelectThemeColorUseCase {
    /// テーマカラーを変更する
    /// - parameter themeColor: テーマカラー
    func updateThemeColor(themeColor: ThemeColor)
}

protocol SelectThemeColorPresentationOutput {
    /// データ処理の成功を出力
    func outputSuccess()
    
    /// エラーを出力
    func outputError()
}
