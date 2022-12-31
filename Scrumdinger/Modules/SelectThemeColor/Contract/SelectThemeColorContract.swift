protocol SelectThemeColorPresentation {
    /// カラーをタップした
    /// - parameter themeColor: 選択したカラー
    func didTapColor(themeColor: ThemeColor)
}

protocol SelectThemeColorPresentationOutput {
    /// カラー一覧を出力する
    func outputColorList()
}
