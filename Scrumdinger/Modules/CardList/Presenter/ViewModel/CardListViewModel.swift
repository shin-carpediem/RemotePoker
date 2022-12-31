import SwiftUI

class CardListViewModel: ObservableObject {
    /// テーマカラー
    @Published var themeColor: ThemeColor = .oxblood
    
    /// ヘッダーテキスト
    @Published var headerTitle = ""
    
    /// ユーザーのカード選択状況
    @Published var userSelectStatus: [UserSelectStatus] = []
    
    /// 選択済みカード一覧が公開されるか
    @Published var isShownSelectedCardList = false
    
    /// ボタンが有効か
    @Published var isButtonEnabled = true
    
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
