import FirebaseCore
import SwiftUI

@main
struct ScrumdingerApp: App, ModuleAssembler {
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

        /// Firebaseをセットアップする
        private func setupFirebase() {
            let googleServiceInfo: String = {
                #if DEBUG
                    // 開発環境
                    return "GoogleService-Info-Dev"
                #else
                    // 本番環境
                    return "GoogleService-Info"
                #endif
            }()

            guard let filePath = Bundle.main.path(forResource: googleServiceInfo, ofType: "plist")
            else {
                assert(false, "Could not load Firebase config file.")
            }
            guard let options = FirebaseOptions(contentsOfFile: filePath) else {
                assert(false, "Could not load Firebase config file.")
            }
            FirebaseApp.configure(options: options)
        }
    }

    // MARK: - View

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            NavigationView {
                let currentRoomId = LocalStorage.shared.currentRoomId
                if currentRoomId == 0 {
                    // ログインしていない
                    assmebleEnterRoom()
                } else {
                    // ログイン中(currentUserName、cardPackageIdは後で取得)
                    assembleCardList(
                        roomId: currentRoomId,
                        currentUserId: LocalStorage.shared.currentUserId,
                        currentUserName: "",
                        cardPackageId: "",
                        isExisingUser: true)
                }
            }
        }
    }
}
