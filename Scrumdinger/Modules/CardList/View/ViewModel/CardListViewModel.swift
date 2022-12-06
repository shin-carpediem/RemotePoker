import SwiftUI

class CardListViewModel: ObservableObject {
    /// ヘッダーテキスト
    @Published var headerTitle: String = ""
    
    /// 選択済みカード一覧
    @Published var selectedCardList: [SelectedCard] = []
    
    /// 次の画面に遷移するか
    @Published var willPushNextView = false
    
    /// 選択済みカード一覧が公開されているか
    @Published var isOpenSelectedCardList: Bool = false
}
