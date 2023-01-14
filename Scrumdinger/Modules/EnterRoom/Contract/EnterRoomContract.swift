import Foundation

protocol EnterRoomObservable: ObservableObject, ViewModel {
    /// 入力フォーム/名前
    @MainActor var inputName: String { get set }

    /// 入力フォーム/ルームID
    @MainActor var inputRoomId: String { get set }

    /// 入力フォーム内容が有効か
    @MainActor var isInputFormValid: Bool { get }

    /// 入力フォーム内容が有効か評価されて表示されるメッセージ
    @MainActor var inputFormvalidatedMessage: String { get }

    /// 入室中のルームに入るか促すアラートを表示するか
    @MainActor var isShownEnterCurrentRoomAlert: Bool { get set }

    /// カード一覧画面に遷移するか
    @MainActor var willPushCardListView: Bool { get set }
}

protocol EnterRoomPresentation: Presentation {
    /// カレントユーザー
    var currentUser: User { get }

    /// カレントルーム
    var currentRoom: Room { get }

    /// 入室中のルームに入るボタンが押された
    func didTapEnterCurrentRoomButton()

    /// 入室中のルームに入るキャンセルが押された
    func didCancelEnterCurrentRoomButton()

    /// ルームに入るボタンが押された
    /// - parameter inputUserName: 入力されたユーザー名
    /// - parameter inputRoomId: 入力されたルームID
    func didTapEnterRoomButton(inputUserName: String, inputRoomId: String)
}

protocol EnterRoomUseCase: AnyObject {
    /// ルームIDを必要とするルームリポジトリを有効にする
    /// - parameter roomId: ルームID
    func setupRoomRepository(roomId: Int)

    /// ルームが存在するか確認する
    /// - parameter roomId: ルームID:
    func checkRoomExist(roomId: Int) async

    /// ユーザーを要求する
    /// - parameter userId:　ユーザーID
    func requestUser(userId: String)

    /// ルームを要求する
    /// - parameter roomId: ルームID
    func requestRoom(roomId: Int) async

    /// ルームにユーザーを追加する
    /// - parameter user: ユーザー
    func adduserToRoom(user: User) async

    /// ルームを新規作成する
    /// - parameter room: ルーム
    func createRoom(room: Room) async
}

protocol EnterRoomInteractorOutput: AnyObject {
    /// ユーザーを出力する
    func outputUser(_ user: User)

    /// ルームを出力する
    func outputRoom(_ room: Room)

    /// ルームが存在するかを出力する
    func outputRoomExist(_ exist: Bool)

    /// データ処理の成功を出力
    @MainActor func outputSuccess(message: String)

    /// エラーを出力
    @MainActor func outputError(_ error: Error, message: String)
}
