import FirebaseCore
import FirebaseFirestore
import Foundation

/// テスト用の仮想のFirebaseプロジェクトを作成するヘルパー
struct FirebaseTestHelper {
    static let shard = FirebaseTestHelper()

    /// テスト環境をセットアップする
    func setupFirebaseTestApp() {
        if FirebaseApp.app() != nil { return }

        let options = FirebaseOptions(googleAppID: "1:123:ios:123abc", gcmSenderID: "sender_id")
        options.projectID = "test-" + UUID().uuidString
        FirebaseApp.configure(options: options)

        let settings = FirestoreSettings()
        settings.host = "localhost:8080"
        settings.isSSLEnabled = false

        print("🍎 Firebase Test App has been configured.")
    }

    /// テスト環境を削除する
    func deleteFirebaseTestApp() {
        guard let app = FirebaseApp.app() else { return }
        app.delete { _ in
            print("🤖 Firebase Test App has been deleted.")
        }
    }

    // MARK: - Private

    private init() {}
}
