import Foundation

class SettingViewModel: ObservableObject {
    /// ボタンが有効か
    @Published var isButtonEnabled = true
    
    /// 通知バナーを表示するか
    @Published var isShownBanner = false
    
    /// 通知バナーのメッセージ
    @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")
    
    // MARK: - Router
    
    /// テーマカラー選択画面に遷移するか
    @Published var willPushSelectThemeColorView = false
}
