import FirebaseFirestore
import FirebaseFirestoreSwift
import XCTest

@testable import RemotePokerData

final class EnterRoomDataStoreTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        FirebaseTestHelper.shard.deleteFirebaseTestApp()
    }

    /// ルームを作成し、それが存在することをテストする
    func test_createRoom() async throws {
        // テスト対象オブジェクト
        let user = UserEntity(
            id: "0",
            name: "ユーザー",
            selectedCardId: nil)
        let card = CardPackageEntity.Card(
            id: 0,
            estimatePoint: "1",
            index: 0)
        let cardPackage = CardPackageEntity(
            id: 0,
            themeColor: "sky",
            cardList: [card])
        let room = RoomEntity(
            id: 0,
            userIdList: [user.id],
            cardPackage: cardPackage)

        // モックオブジェクト注入
        let dataStore = EnterRoomDataStore()

        // ルームの作成
        let _ = await dataStore.createRoom(room)
        let roomExist: Bool = await dataStore.checkRoomExist(roomId: String(room.id))

        XCTAssertTrue(roomExist, "ルームを作成し、それが存在する")
    }
}
