import SwiftUI

extension ModuleAssembler {
    func assmebleEnterRoom() -> EnterRoomView {
        let dataStore = RoomDataStore()
        let presenter = EnterRoomPresenter(dependency: .init(dataStore: dataStore))
        let view = EnterRoomView(dependency: .init(presenter: presenter))
        return view
    }
    
    func assembleCardList(room: Room, currrentUser: User) -> CardListView {
        let dataStore = RoomDataStore()
        let presenter = CardListPresenter(dependency: .init(
            dataStore: dataStore,
            room: room,
            currentUser: currrentUser))
        let view = CardListView(dependency: .init(
            presenter: presenter,
            room: room,
            currentUser: currrentUser))
        return view
    }
}
