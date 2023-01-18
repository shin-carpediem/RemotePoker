import Foundation

protocol EnterRoomObservable: ObservableObject, ViewModel {
    /// 入力フォーム/名前
    @MainActor
    var inputName: String { get set }

    /// 入力フォーム/ルームID
    @MainActor
    var inputRoomId: String { get set }

    /// 入力フォーム内容が有効か
    @MainActor
    var isInputFormValid: Bool { get }

    /// 入力フォーム内容が有効か評価されて表示されるメッセージ
    @MainActor
    var inputFormvalidatedMessage: String { get }

    /// カード一覧画面に遷移するか
    @MainActor
    var willPushCardListView: Bool { get set }
}

protocol EnterRoomPresentation: Presentation {
    /// カレントユーザー
    var currentUser: User { get }

    /// カレントルーム
    var currentRoom: Room { get }

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
    /// - returns ルームが存在するか
    func checkRoomExist(roomId: Int) async -> Bool

    /// ルームにユーザーを追加する
    /// - parameter user: ユーザー
    func adduserToRoom(user: User) async

    /// ルームを新規作成する
    /// - parameter room: ルーム
    func createRoom(room: Room) async
}

protocol EnterRoomInteractorOutput: AnyObject {
    /// データ処理の成功を出力
    @MainActor
    func outputSuccess(message: String)

    /// エラーを出力
    @MainActor
    func outputError(_ error: Error, message: String)
}
