enum FirebaseError: Error {
    /// ログインに失敗した
    case failedToLogin

    /// ログアウトに失敗した
    case failedToLogout

    /// ルームの新規作成に失敗した
    case failedToCreateRoom

    /// 指定IDのルームの取得に失敗した
    case failedToFetchRoom

    /// ルームへのユーザー追加に失敗した
    case failedToAddUserToRoom

    /// ルームからの退出に失敗した
    case failedToRemoveUserFromRoom

    /// 指定IDのユーザー取得に失敗した
    case failedToFetchUser
}
