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

        private func setupFirebase() {
            FirebaseApp.configure()
        }
    }

    // MARK: - View

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if LocalStorage.shared.currentRoomId != 0 {
                    // ログイン中(currentUserId, currentUserNameは後で取得)
                    assembleCardList(
                        roomId: LocalStorage.shared.currentRoomId,
                        currentUserId: "",
                        currentUserName: "",
                        cardPackageId: "")
                } else {
                    // ログインしていない
                    assmebleEnterRoom()
                }
            }
        }
    }
}
