import SwiftUI

actor EnterRoomViewModel: ObservableObject, ViewModel {
    /// 入力フォーム/名前
    @MainActor @Published var inputName = ""
    
    /// 入力フォーム/ルームID
    @MainActor @Published var inputRoomId = ""
    
    /// 入室中のルームに入るか促すアラートを表示するか
    @MainActor @Published var isShownEnterCurrentRoomAlert = false
    
    /// 入力フォーム内容の無効を示すアラートを表示するか
    @MainActor @Published var isShownInputFormInvalidAlert = false
    
    // MARK: - ViewModel
    
    @MainActor @Published var isButtonEnabled = true
    
    @MainActor @Published var isShownLoader = false
    
    @MainActor @Published var isShownBanner = false
    
    @MainActor @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")
    
    // MARK: - Router
    
    /// カード一覧画面に遷移するか
    @MainActor @Published var willPushCardListView = false
}
