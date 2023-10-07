public enum FirebaseError: Error {
    /// サインインに失敗した
    case failedToSignin
    /// ログアウトに失敗した
    case failedToSignOut
    /// ユーザーの新規作成に失敗した
    case failedToCreateUser
    /// ルームの新規作成に失敗した
    case failedToCreateRoom
    /// ルームへのユーザー追加に失敗した
    case failedToAddUserToRoom
    /// ルームからの退出に失敗した
    case failedToRemoveUserFromRoom
    /// 指定IDのユーザー取得に失敗した
    case failedToFetchUser
}
