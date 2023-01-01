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
