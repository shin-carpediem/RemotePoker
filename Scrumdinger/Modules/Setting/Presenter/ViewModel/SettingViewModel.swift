import Foundation

class SettingViewModel: ObservableObject {
    /// ボタンが有効か
    @Published var isButtonEnabled = true
    
    // MARK: - Router
    
    /// テーマカラー選択画面に遷移するか
    @Published var willPushSelectThemeColorView = false
}
