import FirebaseCore
import SwiftUI

@main
struct RemotePokerApp: App, ModuleAssembler {
    // MARK: - App

    class AppDelegate: NSObject, UIApplicationDelegate {
        // MARK: - UIApplicationDelegate

        func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? =
                nil
        ) -> Bool {
            setupFirebase()
            return true
        }

        // MARK: - Private

        private static let googleServiceInfoFilePath: String? = {
            let googleServiceInfo: String = {
                #if DEBUG
                    // 開発環境
                    return "GoogleService-Info-Dev"
                #else
                    // 本番環境
                    return "GoogleService-Info"
                #endif
            }()
            return Bundle.main.path(forResource: googleServiceInfo, ofType: "plist")
        }()

        /// Firebaseをセットアップする
        private func setupFirebase() {
            guard let filePath: String = Self.googleServiceInfoFilePath
            else {
                fatalError("Could not load Firebase config file.")
            }
            guard let options = FirebaseOptions(contentsOfFile: filePath) else {
                fatalError("Could not load Firebase config file.")
            }
            FirebaseApp.configure(options: options)
        }
    }

    // MARK: - View

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            NavigationView {
                let currentRoomId: Int = LocalStorage.shared.currentRoomId
                let isUserLoggedIn: Bool = !(currentRoomId == 0)
                if isUserLoggedIn {
                    // ログイン中(currentUserName、cardPackageIdは後で取得)
                    assembleCardListModule(
                        roomId: currentRoomId,
                        currentUserId: LocalStorage.shared.currentUserId,
                        currentUserName: "",
                        cardPackageId: "",
                        isExisingUser: true)
                } else {
                    // ログインしていない
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
