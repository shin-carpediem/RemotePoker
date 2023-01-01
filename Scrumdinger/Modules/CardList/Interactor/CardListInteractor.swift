import Foundation

class CardListInteractor: CardListUseCase {
    // MARK: - Dependency
    
    struct Dependency {
        var dataStore: RoomDataStore
        var authDataStore: RoomAuthDataStore
        var presenter: CardListPresenter?
        var room: Room
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
        dependency.dataStore.delegate = self
    }
    
    var dependency: Dependency
    
    // MARK: - CardListUseCase
    
    func subscribeCardPackages() {
        dependency.dataStore.subscribeCardPackage()
    }
    
    func unsubscribeCardPackages() {
        dependency.dataStore.unsubscribeCardPackage()
    }
    
    func subscribeUsers() {
        dependency.dataStore.subscribeUser()
    }
    
    func unsubscribeUsers() {
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
    
    func isUserLoggedIn() -> Bool {
        dependency.authDataStore.isUserLogin()
    }
}

// MARK: - RoomDelegate

extension CardListInteractor: RoomDelegate {
    func whenCardPackageChanged(actionType: CardPackageActionType) {
        switch actionType {
        case .modified:
            // カードパッケージのテーマカラーが変更された時
            dependency.presenter?.outputThemeColor()
        case .added, .removed:
            return
        case .unKnown:
            fatalError()
        }
    }
    
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
