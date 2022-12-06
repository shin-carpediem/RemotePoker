import SwiftUI

class CardListViewModel: ObservableObject {
    /// ヘッダーテキスト
    @Published var headerTitle: String = ""
    
    /// 選択済みカード一覧が公開されているか
    @Published var isOpenSelectedCardList: Bool = false
}
