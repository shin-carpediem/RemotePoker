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

    // MARK: - View

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            NavigationView {
                let currentRoomId: Int = LocalStorage.shared.currentRoomId
                let isUserSignedIn: Bool = !(currentRoomId == 0)
                if isUserSignedIn {
                    // サインイン中(currentUserName、cardPackageIdは後で取得)
                    assembleCardListModule(
                        roomId: currentRoomId,
                        currentUserId: LocalStorage.shared.currentUserId,
                        currentUserName: "",
                        cardPackageId: "",
                        isExisingUser: true)
                } else {
                    // サインインしていない
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
