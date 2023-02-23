import Combine
import FirebaseAuth

final class AuthDataStore: AuthRepository {
    static let shared = AuthDataStore()

    // MARK: - RoomAuthRepository

    func signIn() -> Future<String, Never> {
        Future<String, Never> { promise in
            Auth.auth().signInAnonymously { authResult, error in
                if error != nil {
                    fatalError()
                }
                guard let userId: String = authResult?.user.uid else {
                    fatalError()
                }
                promise(.success(userId))
            }
        }
    }

    func signOut() -> Result<Void, FirebaseError> {
        do {
            try Auth.auth().signOut()
            return .success(())
        } catch (_) {
            return .failure(.failedToSignOut)
        }
    }

    // MARK: - Private

    // 外部からのインスタンス生成をコンパイルレベルで禁止
    private init() {}
}
