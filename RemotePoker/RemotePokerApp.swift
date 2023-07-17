import Model
import RemotePokerData
import RemotePokerDomains
import RemotePokerViews
import Shared
import SwiftUI

@main struct RemotePokerApp: App, ModuleAssembler {
    // MARK: - App

    class AppDelegate: NSObject, UIApplicationDelegate {
        // MARK: - UIApplicationDelegate

        func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? =
                nil
        ) -> Bool {
            FirebaseEnvironment.shared.setup()
            Task { @MainActor in
                await isUserSignedIn = checkUserSignedIn()
                let currentUser = UserModel(
                    id: LocalStorage.shared.currentUserId, name: "",
                    selectedCardId: ""
                )
                // TODO: ここを通るより先に、viewの内部の処理が走ってしまう。
                AppConfigManager.appConfig = .init(
                    currentUser: currentUser,
                    currentRoom: .init(id: LocalStorage.shared.currentRoomId, userList: [currentUser], cardPackage: .defaultCardPackage)
                )
                return true
            }
            // ここを通ることはない。
            return false
        }
        
        // MARK: - Private
        
        private func checkUserSignedIn() async -> Bool {
            do {
                let userId: String = try await AuthDataStore.shared.signIn().value
                return LocalStorage.shared.currentUserId == userId
            } catch (_) {
                return false
            }
        }
    }
    
    // MARK: - Private
    
    private static var isUserSignedIn = false

    // MARK: - View

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if Self.isUserSignedIn {
                    assembleCardListModule()
                } else {
                    assmebleEnterRoomModule()
                }
            }
            // NavigationViewを使用した際にiPadでは、Master-Detail(Split view)の挙動になっている。
            // そしてMasterとなるViewが配置されていない為、空白のViewが表示されてしまう。
            // iPadはサポート外なので、iPhoneでもiPadでも同じ見た目に固定する。
            .navigationViewStyle(.stack)
        }
    }
}
