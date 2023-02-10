import Foundation

protocol EnterRoomObservable: ObservableObject {
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

protocol EnterRoomPresentation: AnyObject, Presentation {
    /// カレントユーザー
    var currentUser: UserEntity { get }

    /// カレントルーム
    var currentRoom: RoomEntity { get }

    /// ルームに入るボタンが押された
    /// - parameter inputUserName: 入力されたユーザー名
    /// - parameter inputRoomId: 入力されたルームID
    func didTapEnterRoomButton(inputUserName: String, inputRoomId: String)
}

protocol EnterRoomUseCase: AnyObject {
    /// ルームが存在するか確認する
    /// - parameter roomId: ルームID
    /// - returns ルームが存在するか
    func checkRoomExist(roomId: Int) async -> Bool

    /// ルームを新規作成する
    /// - parameter room: ルーム
    func createRoom(room: RoomEntity) async

    /// ルームにユーザーを追加する
    /// - parameter roomId: ルームID
    /// - parameter user: ユーザー
    func adduserToRoom(roomId: Int, user: UserEntity) async
}

protocol EnterRoomInteractorOutput: AnyObject {
    /// データ処理の成功を出力
    @MainActor
    func outputSuccess(message: String)

    /// エラーを出力
    @MainActor
    func outputError(_ error: Error, message: String)
}
