import FirebaseAuth

final class RoomAuthDataStore: RoomAuthRepository {
    // MARK: - RoomAuthRepository

    static var shared = RoomAuthDataStore()

    func fetchUserId() -> String? {
        Auth.auth().currentUser?.uid
    }

    func isUserLoggedIn(completion: @escaping (Bool) -> Void) {
        if let isUserLogin = Auth.auth().currentUser?.isAnonymous {
            completion(isUserLogin)
        } else {
            completion(false)
        }
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

    // 外部からのインスタンス生成をコンパイルレベルで禁止
    private init() {}
}
