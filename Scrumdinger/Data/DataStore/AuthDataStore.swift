import FirebaseAuth

final class AuthDataStore: AuthRepository {
    static let shared = AuthDataStore()

    // MARK: - RoomAuthRepository

    func login(completion: @escaping (Result<String, FirebaseError>) -> Void) {
        Auth.auth().signInAnonymously { authResult, error in
            if let userId = authResult?.user.uid {
                completion(.success(userId))
            } else {
                completion(.failure(.failedToLogin))
            }
        }
    }

    func logout() -> Result<Void, FirebaseError> {
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
