import SwiftUI

class CardListViewModel: ObservableObject, ViewModel {
    /// ルーム
    @Published var room: Room?
    
    /// ヘッダーテキスト
    @Published var headerTitle = ""
    
    /// ユーザーのカード選択状況一覧
    @Published var userSelectStatusList: [UserSelectStatus] = []
    
    /// 選択済みカード一覧が公開されるか
    @Published var isShownSelectedCardList = false
    
    // MARK: - ViewModel
    
    @Published var isButtonEnabled = true
    
    @Published var isShownBanner = false
    
    @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")
    
    // MARK: - Router
    
    /// 設定画面に遷移するか
    @Published var willPushSettingView = false
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
