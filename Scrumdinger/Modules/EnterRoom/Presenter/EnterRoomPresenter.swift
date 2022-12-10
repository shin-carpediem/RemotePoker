import Foundation

class EnterRoomPresenter: EnterRoomPresentation, EnterRoomPresentationOutput {
    // MARK: - Dependency
    
    struct Dependency {
        var dataStore: RoomDataStore
        var viewModel: EnterRoomViewModel
    }
    
    /// ルーム
    var room: Room?
    
    /// カレントユーザー
    var currentUser: User = .init(id: "", name: "")
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        let currentUserId = AppConfig.shared.currentUserId
        if !currentUserId.isEmpty {
            currentUser.id = currentUserId
            currentUser.name = self.dependency.dataStore.fetchUserName(id: currentUserId)
        } else {
            AppConfig.shared.resetLocalLogInData()
            currentUser.id = UUID().uuidString
            currentUser.name = ""
        }
    }
    
    // MARK: - EnterRoomPresentation
    
    func isInputFormValid() -> Bool {
        guard !dependency.viewModel.inputName.isEmpty else { return false }
        guard let inputInt = Int(dependency.viewModel.inputRoomId) else { return false }
        return String(inputInt).count == 4
    }
    
    func didTapEnterExistingRoomButton() async {
        disableButton(true)
        let roomId = AppConfig.shared.currentUserRoomId
        let roomExist = await dependency.dataStore.checkRoomExist(roomId: roomId)
        if roomExist {
            // 既存ルーム
            dependency.dataStore = RoomDataStore(roomId: roomId)
            room = await dependency.dataStore.fetchRoom()
            
            pushCardListView()
        } else {
            AppConfig.shared.resetLocalLogInData()
            disableButton(false)
        }
    }
    
    func didTapEnterRoomButton(userName: String, roomId: Int) async {
        disableButton(true)
        
        currentUser.name = userName
        let roomExist = await dependency.dataStore.checkRoomExist(roomId: roomId)
        if roomExist {
            // 既存ルーム
            if AppConfig.shared.isCurrentUserLoggedIn {
                // ルームにログインしている
                pushCardListView()
            } else {
                // ルームにログインしていない
                dependency.dataStore = RoomDataStore(roomId: roomId)
                room = await dependency.dataStore.fetchRoom()

                await dependency.dataStore.addUserToRoom(user: .init(
                    id: currentUser.id,
                    name: currentUser.name,
                    selectedCard: nil))
                room?.userList.append(currentUser)
            }
        } else {
            // 新規ルーム
            room = Room(id: roomId,
                        userList: [.init(
                            id: currentUser.id,
                            name: currentUser.name,
                            selectedCard: nil)],
                        cardPackage: .sampleCardPackage)

            await dependency.dataStore.createRoom(room!)
        }

        addLocalLogInData()
        pushCardListView()
    }
    
    // MARK: - EnterRoomPresentationOutput
    
    func outputLoginAsCurrentUserAlert() {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.isShownLoginAsCurrentUserAlert = true
        }
    }
    
    func outputInputInvalidAlert() {
        // TODO: Actorで置き換える
        // https://qiita.com/uhooi/items/1d2c94df69c75fcfbdbf
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.isShownInputFormInvalidAlert = true
        }
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    private func disableButton(_ disabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.isButtonEnabled = !disabled
            self?.dependency.viewModel.activityIndicator.isAnimating = disabled
        }
    }
    
    private func addLocalLogInData() {
        AppConfig.shared.isCurrentUserLoggedIn = true
        AppConfig.shared.currentUserId = currentUser.id
        AppConfig.shared.currentUserRoomId = room?.id ?? 0
    }
    
    // MARK: - Router
    
    private func pushCardListView() {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.willPushCardListView = true
        }
        disableButton(false)
    }
}
