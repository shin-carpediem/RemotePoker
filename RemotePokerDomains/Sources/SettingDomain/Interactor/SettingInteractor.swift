import Foundation
import Protocols
import RemotePokerData
import Shared

public final class SettingInteractor: DependencyInjectable {
    public init() {}

    // MARK: - DependencyInjectable

    public struct Dependency {
        public var repository: RoomRepository
        public weak var output: SettingInteractorOutput?

        public init(
            repository: RoomRepository, output: SettingInteractorOutput?
        ) {
            self.repository = repository
            self.output = output
        }
    }

    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - Private

    private var dependency: Dependency!
}

// MARK: - SettingUseCase

extension SettingInteractor: SettingUseCase {
    public func leaveRoom() async {
        resetLocalStorage()
        unsubscribeCurrentRoom()

        guard let appConfig = AppConfigManager.appConfig else {
            fatalError()
        }
        let result: Result<Void, FirebaseError> = await dependency.repository.removeUserFromRoom(
            userId: appConfig.currentUser.id)
        switch result {
        case .success:
            let signoutResult: Result<Void, FirebaseError> = AuthDataStore.shared.signOut()
            switch signoutResult {
            case .success:
                dependency.output?.outputSuccess(message: "ルームから退出しました")

            case .failure(let error):
                dependency.output?.outputError(error, message: "ルームから退出できませんでした")
            }

        case .failure(let error):
            dependency.output?.outputError(error, message: "ルームから退出できませんでした")
        }
    }
}

// MARK: - Private

extension SettingInteractor {
    private func resetLocalStorage() {
        LocalStorage.shared.currentRoomId = 0
        LocalStorage.shared.currentUserId = ""
    }

    private func unsubscribeCurrentRoom() {
        dependency.repository.unsubscribeRoom()
    }
}
