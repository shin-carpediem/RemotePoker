import FirebaseCore
import SwiftUI

@main
struct ScrumdingerApp: App, ModuleAssembler {
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? =
                nil
        ) -> Bool {
            FirebaseApp.configure()
            return true
        }
    }

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            NavigationView {
                assmebleEnterRoom()
            }
        }
    }
}
