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
    var currentUser: User = .init(id: UUID().uuidString,
                                  name: "",
                                  selectedCard: nil)
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - EnterRoomPresentation
    
    func isInputFormValid() -> Bool {
        guard !dependency.viewModel.inputName.isEmpty else { return false }
        guard let inputInt = Int(dependency.viewModel.inputRoomId) else { return false }
        return String(inputInt).count == 4
    }
    
    func didTapEnterRoomButton(userName: String, roomId: Int) async {
        currentUser.name = userName
        let roomExist = await dependency.dataStore.checkRoomExist(roomId: roomId)
        if roomExist {
            // 既存ルーム
            dependency.dataStore = RoomDataStore(roomId: roomId)
            room = await dependency.dataStore.fetchRoom()
            await dependency.dataStore.addUserToRoom(user: .init(
                id: currentUser.id,
                name: userName,
                selectedCard: nil))
            room?.userList.append(currentUser)
        } else {
            // 新規ルーム
            room = Room(id: roomId,
                        userList: [.init(
                            id: currentUser.id,
                            name: userName,
                            selectedCard: nil)],
                        cardPackage: .sampleCardPackage)
            await dependency.dataStore.createRoom(room!)
        }
        
        pushNextView(true)
    }
    
    // MARK: - EnterRoomPresentationOutput
    
    func outputInputInvalidAlert() {
        // TODO: Actorで置き換える
        // https://qiita.com/uhooi/items/1d2c94df69c75fcfbdbf
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.isShownInputFormInvalidAlert = true
        }
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    // MARK: - Router
    
    private func pushNextView(_ willPush: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.willPushNextView = willPush
        }
    }
}
