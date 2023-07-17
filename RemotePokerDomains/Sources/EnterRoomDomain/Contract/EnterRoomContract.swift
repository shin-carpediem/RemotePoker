import Foundation
import Model
import Protocols
import ViewModel

public protocol EnterRoomPresentation: AnyObject, Presentation {
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
    
    /// ユーザーを新規作成する
    /// - parameter user: ユーザー
    func createUser(_ user: UserModel) async

    /// ルームが存在するか確認する
    /// - parameter roomId: ルームID
    /// - returns: ルームが存在するか
    func checkRoomExist(by roomId: Int) async -> Bool

    /// ルームを新規作成する
    /// - parameter room: ルーム
    func createRoom(_ room: RoomModel) async

    /// ルームにユーザーを追加する
    /// - parameter roomId: ルームID
    /// - parameter userId: ユーザーID
    func adduserToRoom(roomId: Int, userId: String) async
}

public protocol EnterRoomInteractorOutput: AnyObject {
    /// サインインの成功を出力する
    func outputSucceedToSignIn(userId: String, userName: String, roomId: Int)

    /// データ処理の成功を出力する
    func outputSuccess(message: String)

    /// エラーを出力する
    func outputError(_ error: Error, message: String)
}
