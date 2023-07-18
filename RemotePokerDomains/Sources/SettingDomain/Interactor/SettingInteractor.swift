import Foundation
import Protocols
import RemotePokerData
import Shared

public final class SettingInteractor: DependencyInjectable {
    public init() {}

    // MARK: DependencyInjectable

    public struct Dependency {
        public var repository: CurrentRoomRepository
        public weak var output: SettingInteractorOutput?

        public init(
            repository: CurrentRoomRepository, output: SettingInteractorOutput?
        ) {
            self.repository = repository
            self.output = output
        }
    }

    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    private var dependency: Dependency!
}

// MARK: SettingUseCase

extension SettingInteractor: SettingUseCase {
    public func leaveRoom() async {
        resetLocalStorage()
        
        dependency.repository.unsubscribeUserList()
        dependency.repository.unsubscribeRoom()

        switch await dependency.repository.removeUserFromRoom() {
        case .success:
            switch AuthDataStore.shared.signOut() {
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

// MARK: Private

extension SettingInteractor {
    private func resetLocalStorage() {
        LocalStorage.shared.currentRoomId = 0
        LocalStorage.shared.currentUserId = ""
    }
}
