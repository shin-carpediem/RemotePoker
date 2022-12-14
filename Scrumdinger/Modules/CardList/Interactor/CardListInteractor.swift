import Foundation

class CardListInteractor: CardListUseCase {
    // MARK: - Dependency
    
    struct Dependency {
        var dataStore: RoomDataStore
        var presenter: CardListPresenter?
        var room: Room
        var currentUser: User
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    var dependency: Dependency
    
    // MARK: - CardListUseCase
    
    func subscribeUser() {
        dependency.dataStore.delegate = self
        dependency.dataStore.subscribeUser()
    }
    
    func unsubscribeUser() {
        dependency.dataStore.unsubscribeUser()
    }
    
    func updateSelectedCardId(selectedCardDictionary: [String: String]) {
        dependency.dataStore.updateSelectedCardId(selectedCardDictionary: selectedCardDictionary)
    }
    
    func fetchRoom() async {
        let task = Task { () -> Room in
            await dependency.dataStore.fetchRoom()
        }
        let result = await task.result
        do {
            let room = try result.get()
            dependency.room = room
            dependency.presenter?.outputRoom(room)
        } catch {
            dependency.presenter?.outputError()
        }
    }
}

// MARK: - RoomDelegate

extension CardListInteractor: RoomDelegate {
    func whenUserChanged(actionType: UserActionType) {
        switch actionType {
        case .added, .removed:
            // ユーザーが入室あるいは退室した時
            dependency.presenter?.outputHeaderTitle()
        case .modified:
            // ユーザーの選択済みカードが更新された時
            dependency.presenter?.outputUserSelectStatus()
        case .unKnown:
            fatalError()
        }
    }
}
