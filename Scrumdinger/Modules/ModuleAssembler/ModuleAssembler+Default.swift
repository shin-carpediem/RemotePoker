extension ModuleAssembler {
    func assmebleEnterRoom() -> EnterRoomView {
        let viewModel = EnterRoomViewModel()
        let presenter = EnterRoomPresenter(
            dependency: .init(
                dataStore: .init(),
                viewModel: viewModel))
        let view = EnterRoomView(
            dependency: .init(presenter: presenter),
            viewModel: viewModel)
        return view
    }
    
    func assembleCardList(room: Room, currrentUser: User) -> CardListView {
        let viewModel = CardListViewModel()
        let interactor = CardListInteractor(
            dependency: .init(
                dataStore: .init(roomId: room.id),
                room: room))
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
        let interactor = SettingInteractor(
            dependency: .init(
                dataStore: .init(roomId: room.id),
                currentUser: currrentUser))
        let presenter = SettingPresenter(
            dependency: .init(
                interactor: interactor,
                viewModel: viewModel))
        let view = SettingView(
            dependency: .init(
                presenter: presenter,
                room: room),
            viewModel: viewModel)
        interactor.dependency.presenter = presenter
        return view
    }
    
    func assembleSelectThemeColor(room: Room) -> SelectThemeColorView {
        let viewModel = SelectThemeColorViewModel()
        let interactor = SelectThemeColorInteractor(
            dependency: .init(
                dataStore: .init(roomId: room.id),
                room: room))
        let presenter = SelectThemeColorPresenter(
            dependency: .init(
                interactor: interactor,
                room: room,
                viewModel: viewModel))
        let view = SelectThemeColorView(
            dependency: .init(presenter: presenter),
            viewModel: viewModel)
        interactor.dependency.presenter = presenter
        return view
    }
}
