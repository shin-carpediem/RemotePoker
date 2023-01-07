import Foundation

class SelectThemeColorViewModel: ObservableObject {
    /// テーマカラー一覧
    @Published var themeColorList: [ThemeColor] = []
    
    /// 選択されたテーマカラー
    @Published var selectedThemeColor: ThemeColor?
    
    /// 通知バナーを表示するか
    @Published var isShownBanner = false
    
    /// 通知バナーのメッセージ
    @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")
}
