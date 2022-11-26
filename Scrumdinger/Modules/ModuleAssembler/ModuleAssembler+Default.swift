extension ModuleAssembler {
    func assmebleEnterRoom() -> EnterRoomView {
        let presenter = EnterRoomPresenter(dependency: .init(dataStore: .init()))
        let view = EnterRoomView(dependency: .init(presenter: presenter))
        return view
    }
    
    func assembleCardList(room: Room, currrentUser: User) -> CardListView {
        let presenter = CardListPresenter(dependency: .init(
            dataStore: .init(roomId: room.id),
            room: room,
            currentUser: currrentUser))
        let view = CardListView(dependency: .init(
            presenter: presenter,
            room: room,
            currentUser: currrentUser))
        return view
    }
}
