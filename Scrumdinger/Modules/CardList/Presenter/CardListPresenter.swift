import Foundation

class CardListPresenter: CardListPresentation, CardListPresentationOutput {
    // MARK: - Dependency
    
    struct Dependency {
        var interactor: CardListInteractor
        var room: Room
        var currentUser: User
        var viewModel: CardListViewModel
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - CardListPresentation
    
    func subscribeUser() {
        dependency.interactor.subscribeUser()
    }
    
    func unsubscribeUser() {
        dependency.interactor.unsubscribeUser()
    }
    
    func didSelectCard(card: Card) {
        disableButton(true)
        let selectedCardDictionary: [String : String] = [dependency.currentUser.id: card.id]
        dependency.interactor.updateSelectedCardId(selectedCardDictionary: selectedCardDictionary)
    }
    
    func didTapOpenSelectedCardListButton() {
        disableButton(true)
        showSelectedCardList()
    }
    
    func didTapResetSelectedCardListButton() {
        disableButton(true)

        // 全員の選択済みカードをリセットする
//        let userIdList: [String] = dependency.viewModel.userSelectStatus.map { $0.user.id }
//        var selectedCardDictionary: [String: String] = [:]
//        userIdList.forEach { selectedCardDictionary[$0] = "" }
        
        // 自分の選択済みカードをリセットする
        let selectedCardDictionary: [String: String] = [dependency.currentUser.id: ""]

        dependency.interactor.updateSelectedCardId(selectedCardDictionary: selectedCardDictionary)

        hideSelectedCardList()
    }
    
    func didTapSettingButton() {
        pushSettingView()
    }
    
    // MARK: - CardListPresentationOutput
    
    func outputRoom(_ room: Room) {
        dependency.room = room
    }
    
    func outputHeaderTitle() {
        Task {
            // Interactor→Firestore
            await dependency.interactor.fetchRoom()

            dependency.currentUser.selectedCardId = dependency.room.userList.first(where: { $0.id == dependency.currentUser.id })?.selectedCardId ?? ""
            
            // PresententationOutput
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                let currentUserName = self.dependency.currentUser.name
                let otherUsersCount = self.dependency.room.userList.count - 1
                let roomId = self.dependency.room.id
                let only = otherUsersCount >= 1 ? "" : "only"
                let s = otherUsersCount >= 2 ? "s" : ""
                let otherUsersText = otherUsersCount >= 1 ? "and \(String(otherUsersCount)) guy\(s)" : ""
                
                let headerTitle = "\(only) \(currentUserName) \(otherUsersText) in Room \(roomId)"

                self.dependency.viewModel.headerTitle = headerTitle
            }
        }
    }
    
    func outputUserSelectStatus() {
        Task {
            // Interactor→Firestore
            await dependency.interactor.fetchRoom()
            
            dependency.currentUser.selectedCardId = dependency.room.userList.first(where: { $0.id == dependency.currentUser.id })?.selectedCardId ?? ""
            
            // PresententationOutput
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                let userSelectStatus: [UserSelectStatus] = self.dependency.room.userList.map { [weak self] user in
                    let cardPackage = self!.dependency.room.cardPackage
                    
                    let id = Int.random(in: 0..<99999999)
                    let themeColor = cardPackage.themeColor
                    let selectedCard: Card? = cardPackage.cardList.first(where: { $0.id == user.selectedCardId })

                    return UserSelectStatus(id: id,
                                            user: user,
                                            themeColor: themeColor,
                                            selectedCard: selectedCard)
                }
                
                self.dependency.viewModel.userSelectStatus = userSelectStatus
                self.disableButton(false)
            }
        }
    }
    
    func outputSuccess() {
        // TODO: 成功メッセージ
    }
    
    func outputError() {
        // TODO: エラーメッセージ
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    /// ボタンを無効にする
    private func disableButton(_ disabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.isButtonEnabled = !disabled
        }
    }
     
    /// 選択されたカード一覧を表示する
    private func showSelectedCardList() {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.isShownSelectedCardList = true
            self?.disableButton(false)
        }
    }
    
    /// 選択されたカード一覧を非表示にする
    private func hideSelectedCardList() {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.isShownSelectedCardList = false
            self?.disableButton(false)
        }
    }
    
    // MARK: - Router
    
    /// 設定画面に遷移する
    private func pushSettingView() {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.willPushSettingView = true
        }
    }
}
