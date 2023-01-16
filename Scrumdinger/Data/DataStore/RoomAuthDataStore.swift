import FirebaseAuth

final class RoomAuthDataStore: RoomAuthRepository {
    // MARK: - RoomAuthRepository

    static var shared = RoomAuthDataStore()

    private(set) var isUsrLoggedIn = false

    func fetchUserId() -> String? {
        Auth.auth().currentUser?.uid
    }

    func subscribeAuth() {
        authListner = Auth.auth().addStateDidChangeListener { auth, user in
            self.isUsrLoggedIn = (user != nil)
        }
    }

    func unsubscribeAuth() -> Result<Void, RoomAuthError> {
        guard let authListner = authListner else {
            return .failure(.failedToUnsubscibeAuth)
        }
        Auth.auth().removeStateDidChangeListener(authListner)
        return .success(())
    }

    func login(completion: @escaping (Result<String, RoomAuthError>) -> Void) {
        Auth.auth().signInAnonymously { authResult, error in
            if let userId = authResult?.user.uid {
                completion(.success(userId))
            } else {
                completion(.failure(.failedToLogin))
            }
        }
    }

    func logout() -> Result<Void, RoomAuthError> {
        do {
            try Auth.auth().signOut()
            return .success(())
        } catch {
            return .failure(.failedToLogout)
        }
    }

    // MARK: - Private

    /// 認証状況のリスナー
    private var authListner: AuthStateDidChangeListenerHandle?

    // 外部からのインスタンス生成をコンパイルレベルで禁止
    private init() {}
}
