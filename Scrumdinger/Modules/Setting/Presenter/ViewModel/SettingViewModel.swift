import Foundation

class SettingViewModel: ObservableObject, ViewModel {
    // MARK: - ViewModel
    
    @Published var isButtonEnabled = true
    
    @Published var isShownBanner = false
    
    @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")
    
    // MARK: - Router
    
    /// テーマカラー選択画面に遷移するか
    @Published var willPushSelectThemeColorView = false
}
