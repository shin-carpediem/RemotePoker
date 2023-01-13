import SwiftUI

final class EnterRoomViewModel: ObservableObject, ViewModel {
    /// 入力フォーム/名前
    @Published var inputName = ""
    
    /// 入力フォーム/ルームID
    @Published var inputRoomId = ""
    
    /// 入室中のルームに入るか促すアラートを表示するか
    @Published var isShownEnterCurrentRoomAlert = false
    
    /// 入力フォーム内容の無効を示すアラートを表示するか
    @Published var isShownInputFormInvalidAlert = false
    
    // MARK: - ViewModel
    
    @Published var isButtonEnabled = true
    
    @Published var isShownLoader = false
    
    @Published var isShownBanner = false
    
    @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")
    
    // MARK: - Router
    
    /// カード一覧画面に遷移するか
    @Published var willPushCardListView = false
}
