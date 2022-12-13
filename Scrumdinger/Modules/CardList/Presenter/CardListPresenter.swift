import Foundation

class CardListPresenter: CardListPresentation, CardListPresentationOutput {
    // MARK: - Dependency
    
    struct Dependency {
        var dataStore: RoomDataStore
        var room: Room
        var currentUser: User
        var viewModel: CardListViewModel
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - CardListPresentation
    
    func subscribeUser() {
        dependency.dataStore.subscribeUser()
    }
    
    func unsubscribeUser() {
        dependency.dataStore.unsubscribeUser()
    }
    
    func didSelectCard(card: Card) async {
        dependency.dataStore.updateSelectedCardId(selectedCardDictionary: [dependency.currentUser.id: card.id])
    }
    
    func didTapOpenSelectedCardListButton() {
        disableButton(true)
        showSelectedCardList()
    }
    
    func didTapResetSelectedCardListButton() async {
        disableButton(true)

        let userIdList: [String] = dependency.viewModel.userSelectStatus.map { $0.user.id }
        var selectedCardDictionary: [String: String] = [:]
        userIdList.forEach { selectedCardDictionary[$0] = "" }
        dependency.dataStore.updateSelectedCardId(selectedCardDictionary: selectedCardDictionary)

        hideSelectedCardList()
    }
    
    func didTapSettingButton() {
        pushSettingView()
    }
    
    // MARK: - CardListPresentationOutput
    
    func outputHeaderTitle() async {
        // Firestoreからデータ取得
        dependency.room = await dependency.dataStore.fetchRoom()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let currentUserName = self.dependency.currentUser.name
            let otherUsersCount = self.dependency.room.userList.count - 1
            let roomId = self.dependency.room.id
            let only = otherUsersCount >= 1 ? "" : "only"
            let s = otherUsersCount >= 2 ? "s" : ""
            let otherUsersText = otherUsersCount >= 1 ? "and \(String(otherUsersCount)) guy\(s)" : ""
            
            let headerTitle = "\(only) \(currentUserName) \(otherUsersText) in Room: \(roomId)"

            self.dependency.viewModel.headerTitle = headerTitle
        }
    }
    
    func outputUserSelectStatus() async {
        // Firestoreからデータ取得
        dependency.room = await dependency.dataStore.fetchRoom()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let userSelectStatus: [UserSelectStatus] = self.dependency.room.userList.map { [weak self] user in
                let cardPackage = self!.dependency.room.cardPackage
                
                let id = Int.random(in: 0..<99999999)
                let themeColor = cardPackage.themeColor
                let selectedCardId: String = user.selectedCardId
                let selectedCard: Card = cardPackage.cardList.first(where: { $0.id == selectedCardId })!

                return UserSelectStatus(id: id,
                                        user: user,
                                        themeColor: themeColor,
                                        selectedCard: selectedCard)
            }
            
            self.dependency.viewModel.userSelectStatus = userSelectStatus
        }
        disableButton(false)
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    private func disableButton(_ disabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.isButtonEnabled = !disabled
        }
    }
        
    private func showSelectedCardList() {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.isShownSelectedCardList = true
        }
    }
    
    private func hideSelectedCardList() {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.isShownSelectedCardList = false
        }
    }
    
    // MARK: - Router
    
    private func pushSettingView() {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.willPushSettingView = true
        }
        disableButton(false)
    }
}

// MARK: - RoomDelegate

extension CardListPresenter: RoomDelegate {
    func whenUserChanged(actionType: UserActionType) {
        switch actionType {
        case .added, .removed:
            // ユーザーが入室あるいは退室した時
//            outputHeaderTitle()
            ()
        case .modified:
            // ユーザーの選択済みカードが更新された時
//            outputUserSelectStatus()
            ()
        case .unKnown:
            fatalError()
        }
    }
}
