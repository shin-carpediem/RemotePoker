import Combine
import FirebaseAuth

public final class AuthDataStore: AuthRepository {
    public static let shared = AuthDataStore()

    // MARK: - RoomAuthRepository

    public func signIn() -> Future<String, FirebaseError> {
        Future<String, FirebaseError> { promise in
            Auth.auth().signInAnonymously { authResult, _ in
                if let userId: String = authResult?.user.uid {
                    promise(.success(userId))
                } else {
                    Log.main.error("failedToSignin")
                    promise(.failure(.failedToSignin))
                }
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
