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
            var shouldLaunchApp: Bool
            shouldLaunchApp = setupFirebase()
            return shouldLaunchApp
        }

        // MARK: - Private

        /// Firebaseをセットアップする(セットアップに成功したかを返却)
        private func setupFirebase() -> Bool {
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
                return false
            }
            guard let options = FirebaseOptions(contentsOfFile: filePath) else {
                return false
            }
            FirebaseApp.configure(options: options)
            return true
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
