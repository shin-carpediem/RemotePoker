import SwiftUI

actor CardListViewModel: ObservableObject, ViewModel {
    /// ルーム
    @MainActor @Published var room = Room(id: 0, userList: [], cardPackage: .defaultCardPackage)
    
    /// ヘッダーテキスト
    @MainActor @Published var headerTitle = ""
    
    /// ユーザーのカード選択状況一覧
    @MainActor @Published var userSelectStatusList: [UserSelectStatus] = []
    
    /// 選択済みカード一覧が公開されるか
    @MainActor @Published var isShownSelectedCardList = false
    
    // MARK: - ViewModel
    
    @MainActor @Published var isButtonEnabled = true
    
    @MainActor @Published var isShownLoader = false
    
    @MainActor @Published var isShownBanner = false
    
    @MainActor @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")
    
    // MARK: - Router
    
    /// 設定画面に遷移するか
    @MainActor @Published var willPushSettingView = false
}

struct UserSelectStatus: Identifiable {
    /// ID
    var id: Int
    
    /// ユーザー
    var user: User
    
    /// テーマカラー
    var themeColor: ThemeColor
    
    /// 選択済みカード
    var selectedCard: Card?
}
