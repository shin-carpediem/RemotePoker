import SwiftUI

class EnterRoomViewModel: ObservableObject {
    /// 入力フォーム/名前
    @Published var inputName = ""
    
    /// 入力フォーム/ルームID
    @Published var inputRoomId = ""
    
    /// 入室中のルームに入るか促すアラートを表示するか
    @Published var isShownEnterCurrentRoomAlert = false
    
    /// 入力フォーム内容の無効を示すアラートを表示するか
    @Published var isShownInputFormInvalidAlert = false
    
    /// ボタンが有効か
    @Published var isButtonEnabled = true
    
    /// インジケーター
    @Published var activityIndicator = ActivityIndicator()
    
    /// 通知バナーを表示するか
    @Published var isShownBanner = false
    
    /// 通知バナーのメッセージ
    @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")
    
    // MARK: - Router
    
    /// カード一覧画面に遷移するか
    @Published var willPushCardListView = false
}
