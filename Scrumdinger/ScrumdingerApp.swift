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
            RoomAuthDataStore.shared.subscribeAuth()
        }
    }

    // MARK: - View

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if RoomAuthDataStore.shared.isUsrLoggedIn {
                    // ログイン中(currentUserId, currentUserNameは後で取得)
                    assembleCardList(
                        roomId: LocalStorage.shared.currentRoomId,
                        currentUserId: RoomAuthDataStore.shared.fetchUserId() ?? "",
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
