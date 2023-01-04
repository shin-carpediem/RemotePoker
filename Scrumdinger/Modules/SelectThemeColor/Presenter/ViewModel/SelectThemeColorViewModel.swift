import Foundation

class SelectThemeColorViewModel: ObservableObject {
    /// テーマカラー一覧
    @Published var themeColorList: [ThemeColor] = []
    
    /// 選択されたテーマカラー
    @Published var selectedThemeColor: ThemeColor?
}
