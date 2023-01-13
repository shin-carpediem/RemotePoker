import SwiftUI

final class CardListViewModel: ObservableObject, ViewModel {
    /// ルーム
    @Published var room = Room(id: 0, userList: [], cardPackage: .defaultCardPackage)
    
    /// ヘッダーテキスト
    @Published var headerTitle = ""
    
    /// ユーザーのカード選択状況一覧
    @Published var userSelectStatusList: [UserSelectStatus] = []
    
    /// 選択済みカード一覧が公開されるか
    @Published var isShownSelectedCardList = false
    
    // MARK: - ViewModel
    
    @Published var isButtonEnabled = true
    
    @Published var isShownLoader = false
    
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
