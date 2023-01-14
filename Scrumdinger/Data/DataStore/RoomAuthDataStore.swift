import FirebaseAuth

final class RoomAuthDataStore: RoomAuthRepository {
    // MARK: - RoomAuthRepository

    static var shared = RoomAuthDataStore()

    weak var delegate: RoomAuthDelegate?

    func fetchUserId() -> String? {
        Auth.auth().currentUser?.uid
    }

    func isUserLoggedIn() -> Bool {
        if let isUserLogin = Auth.auth().currentUser?.isAnonymous {
            return isUserLogin
        } else {
            return false
        }
    }

    func login() {
        Auth.auth().signInAnonymously { [weak self] authResult, error in
            if error != nil {
                self?.delegate?.whenFailedToLogin(error: .failedToLogin)
                return
            }
            guard let authResult = authResult else {
                self?.delegate?.whenFailedToLogin(error: .failedToLogin)
                return
            }
            self?.delegate?.whenSuccessLogin(userId: authResult.user.uid)
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
