import RemotePokerData
import RemotePokerDomains
import RemotePokerViews
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
            return true
        }
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

    // MARK: - View

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if await checkUserSignedIn() {
                    // currentUserName、cardPackageIdは後で取得する
                    assembleCardListModule(isExisingUser: true)
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
