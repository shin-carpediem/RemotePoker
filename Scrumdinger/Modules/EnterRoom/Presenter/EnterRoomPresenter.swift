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
    var currentUser: User = .init(id: "", name: "", selectedCardId: "")
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - EnterRoomPresentation
    
    func fetchCurrentUserLocalData() {
        let currentUserId = AppConfig.shared.currentUserId
        if !currentUserId.isEmpty {
            let name = AppConfig.shared.currentUserName
            // ローカルにカレントユーザーデータが存在する時
            currentUser = .init(id: currentUserId,
                                name: name,
                                selectedCardId: "")
        } else {
            AppConfig.shared.resetLocalLogInData()
            currentUser = .init(id: UUID().uuidString,
                                name: "",
                                selectedCardId: "")
        }
    }
    
    func isInputFormValid() -> Bool {
        guard !dependency.viewModel.inputName.isEmpty else { return false }
        guard let inputInt = Int(dependency.viewModel.inputRoomId) else { return false }
        return String(inputInt).count == 4
    }
    
    func didTapEnterExistingRoomButton() {
        Task {
            disableButton(true)
            let roomId = AppConfig.shared.currentUserRoomId
            let roomExist = await dependency.dataStore.checkRoomExist(roomId: roomId)
            if roomExist {
                // 既存ルーム
                dependency.dataStore = RoomDataStore(roomId: roomId)
                room = await dependency.dataStore.fetchRoom()
                
                pushCardListView()
            } else {
                fatalError()
            }
        }
    }
    
    func didTapEnterRoomButton(userName: String, roomId: Int) {
        Task {
            disableButton(true)
            
            currentUser.name = userName
            let roomExist = await dependency.dataStore.checkRoomExist(roomId: roomId)
            if roomExist {
                dependency.dataStore = RoomDataStore(roomId: roomId)
                room = await dependency.dataStore.fetchRoom()

                // 既存ルーム
                if AppConfig.shared.isCurrentUserLoggedIn {
                    // ルームにログインしている
                    pushCardListView()
                } else {
                    // TODO: ローカルで保持していたデータが消えたがFirestore上ではルームにログインしている場合、ユーザーは追加させない
                    
                    // ルームにログインしていない
                    await dependency.dataStore.addUserToRoom(user: .init(
                        id: currentUser.id,
                        name: currentUser.name,
                        selectedCardId: ""))
                    room!.userList.append(currentUser)
                }
            } else {
                // 新規ルーム
                room = Room(id: roomId,
                            userList: [.init(
                                id: currentUser.id,
                                name: currentUser.name,
                                selectedCardId: "")],
                            cardPackage: .sampleCardPackage)

                await dependency.dataStore.createRoom(room!)
            }

            // ローカルにユーザーデータの一部を保存
            AppConfig.shared.addLocalLogInData(userId: currentUser.id,
                                               userName: currentUser.name,
                                               roomId: room!.id)
            pushCardListView()
        }
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
    
    /// ボタンを無効にする
    private func disableButton(_ disabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.isButtonEnabled = !disabled
            self?.dependency.viewModel.activityIndicator.isAnimating = disabled
        }
    }
    
    // MARK: - Router
    
    /// カード一覧画面に遷移する
    private func pushCardListView() {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.willPushCardListView = true
        }
        disableButton(false)
    }
}
