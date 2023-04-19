import Foundation
import Model
import Protocols
import ViewModel

public protocol EnterRoomPresentation: AnyObject, Presentation {
    /// カレントユーザー
    var currentUser: UserViewModel { get }

    /// カレントルーム
    var currentRoom: RoomViewModel { get }

    /// ルームに入るボタンが押された
    /// - parameter inputUserName: 入力されたユーザー名
    /// - parameter inputRoomId: 入力されたルームID
    func didTapEnterRoomButton(inputUserName: String, inputRoomId: String)
}

public protocol EnterRoomUseCase: AnyObject {
    /// ログインを要求する
    /// - parameter userName: ユーザー名
    /// - parameter roomId: ルームID
    func signIn(userName: String, roomId: Int) async

    /// ルームが存在するか確認する
    /// - parameter roomId: ルームID
    /// - returns ルームが存在するか
    func checkRoomExist(roomId: Int) async -> Bool

    /// ルームを新規作成する
    /// - parameter room: ルーム
    func createRoom(room: RoomModel) async

    /// ルームにユーザーを追加する
    /// - parameter roomId: ルームID
    /// - parameter user: ユーザー
    func adduserToRoom(roomId: Int, user: UserModel) async
}

public protocol EnterRoomInteractorOutput: AnyObject {
    /// ログインの完了を出力
    /// - parameter userId: ユーザーID
    /// - parameter userName: ユーザー名
    /// - parameter roomId: ルームID
    func outputCompletedSignIn(userId: String, userName: String, roomId: Int)

    /// データ処理の成功を出力
    @MainActor
    func outputSuccess(message: String)

    /// エラーを出力
    @MainActor
    func outputError(_ error: Error, message: String)
}
