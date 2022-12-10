import SwiftUI

class EnterRoomViewModel: ObservableObject {
    /// 入力フォーム/名前
    @Published var inputName = ""
    
    /// 入力フォーム/ルームID
    @Published var inputRoomId = ""
    
    /// 入力フォーム内容の無効を示すアラートを表示するか
    @Published var isShownInputFormInvalidAlert = false
    
    /// ボタンが有効か
    @Published var isButtonAbled = true
    
    /// インジケーター
    @Published var activityIndicator = ActivityIndicator()
    
    // MARK: - Router
    
    /// 次の画面に遷移するか
    @Published var willPushNextView = false
}
