import FirebaseCore
import FirebaseFirestore

@testable import RemotePokerData

/// テスト用の仮想のFirebaseプロジェクトを作成するヘルパー
struct FirebaseTestHelper {
    static let shard = FirebaseTestHelper()

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
