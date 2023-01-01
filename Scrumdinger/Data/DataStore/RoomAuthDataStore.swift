import FirebaseAuth

class RoomAuthDataStore: RoomAuthRepository {
    /// ユーザーID(nilならログイン失敗)
    private(set) var userId: String?
    
    // MARK: - RoomAuthRepository
    
    func isUserLogin() -> Bool {
        if let isUserLogin = Auth.auth().currentUser?.isAnonymous {
            return isUserLogin
        } else {
            return false
        }
    }
    
    func login() {
        Auth.auth().signInAnonymously() { authResult, error in
            if error != nil {
                self.userId = nil
            }
            guard let user = authResult?.user else {
                self.userId = nil
                return
            }
            self.userId = user.uid
        }
    }
    
    func logout() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
}
