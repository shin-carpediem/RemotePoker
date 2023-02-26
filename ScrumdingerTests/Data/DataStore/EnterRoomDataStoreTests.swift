import XCTest

@testable import Scrumdinger

class EnterRoomDataStoreTests: XCTestCase {
    // MARK: - Override

    override func setUp() {
        super.setUp()
        FirebaseTestHelper.shard.setupFirebaseTestApp()
    }

    override func tearDown() {
        super.tearDown()
        FirebaseTestHelper.shard.deleteFirebaseTestApp()
    }

    // MARK: - Test

    func testExample() throws {}

    func testPerformanceExample() throws {
        self.measure {}
    }
}
