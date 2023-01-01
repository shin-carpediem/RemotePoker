import FirebaseAuth

class RoomAuthDataStore: RoomAuthRepository {
    // MARK: - RoomAuthRepository
    
    func isUserLogin() -> Bool {
        if let isUserLogin = Auth.auth().currentUser?.isAnonymous {
            return isUserLogin
        } else {
            return false
        }
    }
    
    func login() -> String? {
        var userId: String?
        Auth.auth().signInAnonymously() { authResult, error in
            if error != nil {
                userId = nil
            }
            guard let user = authResult?.user else {
                userId = nil
                return
            }
            userId = user.uid
        }
        return userId
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
