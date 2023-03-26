import FirebaseCore

struct FirebaseEnvironment {
    static let shared = FirebaseEnvironment()

    /// Firebaseをセットアップする
    func setup() {
        guard let filePath: String = infoPlistPath
        else {
            fatalError("Could not load Firebase config file.")
        }
        guard let options = FirebaseOptions(contentsOfFile: filePath) else {
            fatalError("Could not load Firebase config file.")
        }
        FirebaseApp.configure(options: options)
    }

    // MARK: - Private

    private init() {}

    private let infoPlistPath: String? = {
        let googleServiceInfo: String
        #if DEBUG
            // 開発環境
            googleServiceInfo = "GoogleService-Info-Dev"
        #else
            // 本番環境
            googleServiceInfo = "GoogleService-Info"
        #endif

        return Bundle.main.path(forResource: googleServiceInfo, ofType: "plist")
    }()
}
