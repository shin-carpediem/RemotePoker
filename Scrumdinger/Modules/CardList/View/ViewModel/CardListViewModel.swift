import SwiftUI

class CardListViewModel: ObservableObject {
    /// ヘッダーテキスト
    @Published var headerTitle: String = ""
    
    /// ユーザーのカード選択状況
    @Published var userSelectStatus: [UserSelectStatus] = []
    
    /// 選択済みカード一覧が公開されているか
    @Published var isOpenSelectedCardList: Bool = false
    
    /// ボタンが有効か
    @Published var isButtonAbled = true
    
    // MARK: - Router
    
    /// 次の画面に遷移するか
    @Published var willPushNextView = false
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
