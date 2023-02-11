import Combine
import FirebaseAuth

final class AuthDataStore: AuthRepository {
    static let shared = AuthDataStore()

    // MARK: - RoomAuthRepository

    func login() -> Future<String, Never> {
        Future<String, Never> { promise in
            Auth.auth().signInAnonymously { authResult, error in
                if error != nil {
                    fatalError()
                }
                guard let userId = authResult?.user.uid else {
                    fatalError()
                }
                promise(.success(userId))
            }
        }
    }

    func logout() -> Result<Void, FirebaseError> {
        do {
            try Auth.auth().signOut()
            return .success(())
        } catch (_) {
            return .failure(.failedToLogout)
        }
    }

    // MARK: - Private

    // 外部からのインスタンス生成をコンパイルレベルで禁止
    private init() {}
}
