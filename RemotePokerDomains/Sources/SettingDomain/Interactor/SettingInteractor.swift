import Foundation
import Protocols
import RemotePokerData

public final class SettingInteractor: DependencyInjectable {
    public init() {}

    // MARK: - DependencyInjectable

    public struct Dependency {
        public var repository: RoomRepository
        public weak var output: SettingInteractorOutput?
        public var currentUserId: String

        public init(
            repository: RoomRepository, output: SettingInteractorOutput?,
            currentUserId: String
        ) {
            self.repository = repository
            self.output = output
            self.currentUserId = currentUserId
        }
    }

    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
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

// MARK: - SettingUseCase

extension SettingInteractor: SettingUseCase {
    public func leaveRoom() async {
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
                dependency.output?.outputSuccess(message: "ルームから退出しました")

            case .failure(let error):
                dependency.output?.outputError(error, message: "ルームから退出できませんでした")
            }

        case .failure(let error):
            dependency.output?.outputError(error, message: "ルームから退出できませんでした")
        }
    }
}
