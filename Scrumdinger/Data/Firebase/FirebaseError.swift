enum FirebaseError: Error {
    /// ログインに失敗した
    case failedToLogin

    /// ログアウトに失敗した
    case failedToLogout

    /// ルームの新規作成に失敗した
    case failedToCreateRoom

    /// ルームの取得に失敗した
    case failedToFetchRoom

    /// ルームへのユーザー追加に失敗した
    case failedToAddUserToRoom

    /// ルームからの退出に失敗した
    case failedToRemoveUserFromRoom

    /// ユーザーの購読に失敗した
    case failedToSubscribeUser

    /// 指定IDのユーザー取得に失敗した
    case failedToFetchUser

    /// カードパッケージの購読に失敗した
    case failedToSubscribeCardPackage
}