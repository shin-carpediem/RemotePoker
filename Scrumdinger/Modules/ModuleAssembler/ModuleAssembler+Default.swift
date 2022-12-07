extension ModuleAssembler {
    func assmebleEnterRoom() -> EnterRoomView {
        let viewModel = EnterRoomViewModel()
        let presenter = EnterRoomPresenter(
            dependency: .init(
                dataStore: .init(),
                viewModel: viewModel))
        let view = EnterRoomView(
            dependency: .init(
                presenter: presenter),
            viewModel: viewModel)
        return view
    }
    
    func assembleCardList(room: Room, currrentUser: User) -> CardListView {
        let viewModel = CardListViewModel()
        let presenter = CardListPresenter(
            dependency: .init(
                dataStore: .init(roomId: room.id),
                room: room,
                currentUser: currrentUser,
                viewModel: viewModel))
        viewModel.headerTitle = presenter.outputHeaderTitle()
        let view = CardListView(
            dependency: .init(
                presenter: presenter,
                room: room,
                currentUser: currrentUser),
            viewModel: viewModel)
        return view
    }
    
    func assembleOpenCardList(room: Room, userSelectStatus: [UserSelectStatus]) -> OpenCardListView {
        let view = OpenCardListView(
            dependency: .init(
                userSelectStatus: userSelectStatus,
                room: room))
        return view
    }
}
