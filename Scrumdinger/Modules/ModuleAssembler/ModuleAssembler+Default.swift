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
        let interactor = CardListInteractor(
            dependency: .init(
                dataStore: .init(roomId: room.id),
                room: room,
                currentUser: currrentUser))
        let presenter = CardListPresenter(
            dependency: .init(
                interactor: interactor,
                room: room,
                currentUser: currrentUser,
                viewModel: viewModel))
        let view = CardListView(
            dependency: .init(
                presenter: presenter,
                room: room,
                currentUser: currrentUser),
            viewModel: viewModel)
        interactor.dependency.presenter = presenter
        return view
    }
    
    func assembleSetting(room: Room, currrentUser: User) -> SettingView {
        let viewModel = SettingViewModel()
        let presenter = SettingPresenter(
            dependency: .init(
                dataStore: .init(roomId: room.id),
                currentUser: currrentUser,
                viewModel: viewModel))
        let view = SettingView(
            dependency: .init(
                presenter: presenter),
            viewModel: viewModel)
        return view
    }
}
