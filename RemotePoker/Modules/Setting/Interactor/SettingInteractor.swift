import Foundation

final class SettingInteractor: SettingUseCase, DependencyInjectable {
    // MARK: - DependencyInjectable

    struct Dependency {
        var repository: RoomRepository
        weak var output: SettingInteractorOutput?
        var currentUserId: String
    }

    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - SettingUseCase

    func leaveRoom() async {
        resetLocalStorage()
        unsubscribeUser()
        unsubscribeCardPackages()

        let result: Result<Void, FirebaseError> = await dependency.repository.removeUserFromRoom(
            userId: dependency.currentUserId)
        switch result {
        case .success(_):
            let logoutResult: Result<Void, FirebaseError> = AuthDataStore.shared.signOut()
            switch logoutResult {
            case .success(_):
                let message = "ルームから退出しました"
                await dependency.output?.outputSuccess(message: message)

            case .failure(let error):
                let message = "ルームから退出できませんでした"
                await dependency.output?.outputError(error, message: message)
            }

        case .failure(let error):
            let message = "ルームから退出できませんでした"
            await dependency.output?.outputError(error, message: message)
        }
    }

    // MARK: - Private

    private var dependency: Dependency!

    private func resetLocalStorage() {
        LocalStorage.shared.currentRoomId = 0
        LocalStorage.shared.currentUserId = ""
    }

    private func unsubscribeUser() {
        dependency.repository.unsubscribeUser()
    }

    private func unsubscribeCardPackages() {
        dependency.repository.unsubscribeCardPackage()
    }
}