enum FirebaseError: Error {
    /// ログアウトに失敗した
    case failedToSignOut

    /// ルームの新規作成に失敗した
    case failedToCreateRoom

    /// ルームへのユーザー追加に失敗した
    case failedToAddUserToRoom

    /// ルームからの退出に失敗した
    case failedToRemoveUserFromRoom

    /// 指定IDのユーザー取得に失敗した
    case failedToFetchUser
}
