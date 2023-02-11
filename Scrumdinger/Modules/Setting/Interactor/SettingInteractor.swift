import Foundation

final class SettingInteractor: SettingUseCase, DependencyInjectable {
    // MARK: - DependencyInjectable

    struct Dependency {
        var repository: RoomRepository?
        weak var output: SettingInteractorOutput?
        var currentUserId: String
    }

    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - SettingUseCase

    func leaveRoom() async {
        guard let repository = dependency.repository else { return }
        let result = await repository.removeUserFromRoom(
            userId: dependency.currentUserId)
        switch result {
        case .success(_):
            let logoutResult = AuthDataStore.shared.logout()
            switch logoutResult {
            case .success(_):
                dependency.repository = nil
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

    func unsubscribeUser() {
        dependency.repository?.unsubscribeUser()
    }

    func unsubscribeCardPackages() {
        dependency.repository?.unsubscribeCardPackage()
    }

    // MARK: - Private

    private var dependency: Dependency!
}
