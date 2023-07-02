import Combine
import FirebaseAuth

public final class AuthDataStore: AuthRepository {
    public static let shared = AuthDataStore()

    // MARK: - RoomAuthRepository

    public func signIn() -> Future<String, Never> {
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

    public func signOut() -> Result<Void, FirebaseError> {
        do {
            try Auth.auth().signOut()
            return .success(())
        } catch (_) {
            Log.main.error("failedToSignOut")
            return .failure(.failedToSignOut)
        }
    }

    // MARK: - Private

    private init() {}
}
