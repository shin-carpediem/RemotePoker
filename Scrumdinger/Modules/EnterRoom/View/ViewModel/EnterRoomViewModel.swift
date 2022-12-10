import SwiftUI

class EnterRoomViewModel: ObservableObject {
    /// ログインしているか
    // Firebaseではなくローカルで保持する
    @Published var isLoggedIn = AppConfig.shared.isCurrentUserLoggedIn
    
    /// 入力フォーム/名前
    @Published var inputName = ""
    
    /// 入力フォーム/ルームID
    @Published var inputRoomId = ""
    
    /// ログイン済みのルームに入るか促すアラートを表示するか
    @Published var isShownLoginAsCurrentUserAlert = false
    
    /// 入力フォーム内容の無効を示すアラートを表示するか
    @Published var isShownInputFormInvalidAlert = false
    
    /// ボタンが有効か
    @Published var isButtonAbled = true
    
    /// インジケーター
    @Published var activityIndicator = ActivityIndicator()
    
    // MARK: - Router
    
    /// カード一覧画面に遷移するか
    @Published var willPushCardListView = false
}
