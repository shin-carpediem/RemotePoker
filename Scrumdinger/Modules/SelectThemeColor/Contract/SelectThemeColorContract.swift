protocol SelectThemeColorPresentation {
    /// カラーをタップした
    /// - parameter color: 選択したカラー
    func didTapColor(color: ThemeColor)
}

protocol SelectThemeColorPresentationOutput {
    /// カラー一覧を出力する
    func outputColorList()
}
