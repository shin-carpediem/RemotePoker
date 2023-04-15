import FirebaseFirestore
import FirebaseFirestoreSwift
import XCTest

@testable import RemotePokerData

final class EnterRoomDataStoreTests: XCTestCase {
    // MARK: - Override

    override func tearDown() {
        super.tearDown()
        FirebaseTestHelper.shard.deleteFirebaseTestApp()
    }

    // MARK: - XCTestCase

    /// ルームを作成し、それが存在することをテストする
    func test_createRoom() async throws {
        // テスト対象オブジェクト
        let user = UserEntity(
            id: "0",
            name: "ユーザー",
            currentRoomId: 0,
            selectedCardId: "0")
        let card = CardPackageEntity.Card(
            id: "0",
            point: "1",
            index: 0)
        let cardPackage = CardPackageEntity(
            id: "0",
            themeColor: "sky",
            cardList: [card])
        let room = RoomEntity(
            id: 0,
            userList: [user],
            cardPackage: cardPackage)

        // モックオブジェクト注入
        let dataStore = EnterRoomDataStore()

        // ルームの作成
        let _ = await dataStore.createRoom(room)
        let roomExist: Bool = await dataStore.checkRoomExist(roomId: room.id)

        XCTAssertTrue(roomExist, "ルームを作成し、それが存在する")
    }
}
