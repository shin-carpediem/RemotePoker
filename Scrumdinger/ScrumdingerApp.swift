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
            FirebaseApp.configure()
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
