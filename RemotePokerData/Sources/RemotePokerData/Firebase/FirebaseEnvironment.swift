import FirebaseCore
import FirebaseFirestore

public final class FirebaseEnvironment {
    public static let shared = FirebaseEnvironment()

    public private(set) var app: FirebaseApp?

    public func setup() {
        switch environment {
        case .development, .production:
            FirebaseApp.configure(options: firebaseOptions)
            guard let app = FirebaseApp.app() else {
                fatalError("Could not retrieve default app.")
            }
            self.app = app

        case .testing:
            let appName = "secondary"
            FirebaseApp.configure(name: appName, options: firebaseOptions)

            // テスト環境用にFirestoreの設定を変更する
            let settings = FirestoreSettings()
            settings.host = "localhost:8080"
            settings.isSSLEnabled = false

            guard let app = FirebaseApp.app(name: appName) else {
                fatalError("Could not retrieve secondary app.")
            }
            self.app = app
        }
    }

    // MARK: - Private

    private enum Environment {
        /// 開発環境
        case development
        /// テスト実行環境
        case testing
        /// 本番環境
        case production
    }

    private var environment: Environment {
        #if DEBUG
            return isRunningXCTest ? .testing : .development
        #else
            return .production
        #endif
    }

    private var isRunningXCTest: Bool {
        Thread.current.isRunningXCTest
            || (ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil)
            || (NSClassFromString("XCTest") != nil)
    }

    private var infoPlistPath: String? {
        let googleServiceInfo: String
        switch environment {
        case .development:
            googleServiceInfo = "GoogleService-Info-Dev"

        case .testing:
            fatalError("ここに来ることはない")

        case .production:
            googleServiceInfo = "GoogleService-Info"
        }

        return Bundle.main.path(forResource: googleServiceInfo, ofType: "plist")
    }

    private var firebaseOptions: FirebaseOptions {
        switch environment {
        case .development, .production:
            guard let filePath: String = infoPlistPath
            else {
                fatalError("Could not load Firebase config file.")
            }
            guard let options = FirebaseOptions(contentsOfFile: filePath) else {
                fatalError("Could not load Firebase config file.")
            }
            return options
        case .testing:
            let options = FirebaseOptions(googleAppID: "1:123:ios:123abc", gcmSenderID: "sender_id")
            let identifier = "test-" + UUID().uuidString
            options.projectID = identifier
            // API_KEYのフォーマットは`A`から始まる39文字
            options.apiKey = "A" + String(identifier.prefix(38))
            return options
        }
    }
}
