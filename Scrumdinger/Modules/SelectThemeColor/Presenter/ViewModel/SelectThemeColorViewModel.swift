import Foundation

class SelectThemeColorViewModel: ObservableObject, ViewModel {
    /// テーマカラー一覧
    @Published var themeColorList: [ThemeColor] = []
    
    /// 選択されたテーマカラー
    @Published var selectedThemeColor: ThemeColor?
    
    // MARK: - ViewModel
    
    @Published var isButtonEnabled = true
    
    @Published var isShownLoader = false
    
    @Published var isShownBanner = false
    
    @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")
}
