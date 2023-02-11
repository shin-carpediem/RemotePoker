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
            guard let filePath = Self.googleServiceInfoFilePath
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
                let currentRoomId = LocalStorage.shared.currentRoomId
                if currentRoomId == 0 {
                    // ログインしていない
                    assmebleEnterRoomModule()
                } else {
                    // ログイン中(currentUserName、cardPackageIdは後で取得)
                    assembleCardListModule(
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
