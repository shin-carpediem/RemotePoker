import Foundation

protocol SelectThemeColorObservable: ObservableObject, ViewModel {
    /// テーマカラー一覧
    @MainActor
    var themeColorList: [CardPackageThemeColor] { get set }

    /// 選択されたテーマカラー
    @MainActor
    var selectedThemeColor: CardPackageThemeColor? { get set }
}

protocol SelectThemeColorPresentation: AnyObject, Presentation {
    /// カラーをタップした
    /// - parameter color: 選択したカラー
    func didTapColor(color: CardPackageThemeColor)
}
