import Combine
import Foundation

final class CardListInteractor: CardListUseCase, DependencyInjectable {
    // MARK: - DependencyInjectable

    struct Dependency {
        var enterRoomRepository: EnterRoomRepository
        var roomRepository: RoomRepository
        weak var output: CardListInteractorOutput?
    }

    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - CardListUseCase

    func checkRoomExist(roomId: Int) async -> Bool {
        await dependency.enterRoomRepository.checkRoomExist(roomId: roomId)
    }

    func subscribeUsers() {
        userListCancellable = dependency.roomRepository.userList.sink { [weak self] userList in
            guard let self = self else { return }
            Task {
                await self.dependency.output?.outputUserList(userList)
            }
        }
    }

    func subscribeCardPackages() {
        dependency.roomRepository.subscribeCardPackage { [weak self] result in
            guard let self = self else { return }
            Task {
                switch result {
                case .success(let action):
                    switch action {
                    case .modified:
                        // カードパッケージのテーマカラーが変更された時
                        await self.requestRoom()

                    case .added, .removed:
                        return
                    }

                case .failure(let error):
                    let message = "アプリ内に問題が発生しました。再インストールしてください"
                    await self.dependency.output?.outputError(error, message: message)
                }
            }
        }
    }

    func updateSelectedCardId(selectedCardDictionary: [String: String]) {
        dependency.roomRepository.updateSelectedCardId(
            selectedCardDictionary: selectedCardDictionary)
    }

    func requestUser(userId: String) {
        dependency.roomRepository.fetchUser(id: userId) { [weak self] result in
            guard let self = self else { return }
            Task {
                switch result {
                case .success(let user):
                    await self.dependency.output?.outputUser(user)
                    
                case .failure(let error):
                    let message = "ユーザーを見つけられませんでした"
                    await self.dependency.output?.outputError(error, message: message)
                }
            }
        }
    }

    func requestRoom() async {
        let result = await dependency.roomRepository.fetchRoom()
        switch result {
        case .success(let room):
            await dependency.output?.outputRoom(room)

        case .failure(let error):
            let message = "ルームを見つけられませんでした"
            await dependency.output?.outputError(error, message: message)
        }
    }

    // MARK: - Private

    private var dependency: Dependency!
    
    private var userListCancellable: AnyCancellable?
}
