import Foundation

final class CardListInteractor: CardListUseCase, DependencyInjectable {
    // MARK: - DependencyInjectable

    struct Dependency {
        var undefinedRepository: EnterRoomRepository
        var repository: RoomRepository
        weak var output: CardListInteractorOutput?
    }

    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - CardListUseCase

    func checkRoomExist(roomId: Int) async -> Bool {
        await dependency.undefinedRepository.checkRoomExist(roomId: roomId)
    }

    func subscribeUsers() {
        dependency.repository.subscribeUser { [weak self] result in
            guard let self = self else { return }
            Task {
                switch result {
                case .success(let action):
                    switch action {
                    case .added, .removed:
                        // ユーザーが入室あるいは退室した時
                        await self.requestRoom()
                        await self.dependency.output?.showHeaderTitle()
                        await self.dependency.output?.updateUserSelectStatusList()

                    case .modified:
                        // ユーザーの選択済みカードが更新された時
                        await self.requestRoom()
                        await self.dependency.output?.updateUserSelectStatusList()
                    }

                case .failure(let error):
                    let message = "アプリ内に問題が発生しました。再度起動してください"
                    await self.dependency.output?.outputError(error, message: message)
                }
            }
        }
    }

    func unsubscribeUsers() {
        dependency.repository.unsubscribeUser()
    }

    func subscribeCardPackages() {
        dependency.repository.subscribeCardPackage { [weak self] result in
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
                    let message = "アプリ内に問題が発生しました。再度起動してください"
                    await self.dependency.output?.outputError(error, message: message)
                }
            }
        }
    }

    func unsubscribeCardPackages() {
        dependency.repository.unsubscribeCardPackage()
    }

    func updateSelectedCardId(selectedCardDictionary: [String: String]) {
        dependency.repository.updateSelectedCardId(
            selectedCardDictionary: selectedCardDictionary)
    }

    func requestUser(userId: String) {
        dependency.repository.fetchUser(id: userId) { [weak self] user in
            guard let self = self else { return }
            Task {
                await self.dependency.output?.outputUser(user)
            }
        }
    }

    func requestRoom() async {
        let result = await dependency.repository.fetchRoom()
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
}
