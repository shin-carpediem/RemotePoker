extension ModuleAssembler {
    func assmebleEnterRoomModule() -> EnterRoomView {
        let viewModel = EnterRoomViewModel()
        let presenter = EnterRoomPresenter()
        let interactor = EnterRoomInteractor()

        presenter.inject(.init(useCase: interactor, viewModel: viewModel))
        interactor.inject(.init(repository: EnterRoomDataStore(), output: presenter))
        let view = EnterRoomView(dependency: .init(presenter: presenter), viewModel: viewModel)

        return view
    }

    func assembleCardListModule(
        roomId: Int, currentUserId: String, currentUserName: String, cardPackageId: String,
        isExisingUser: Bool
    ) -> CardListView {
        let viewModel = CardListViewModel()
        let presenter = CardListPresenter()
        let interactor = CardListInteractor()

        presenter.inject(
            .init(
                useCase: interactor,
                roomId: roomId,
                currentUserId: currentUserId,
                currentUserName: currentUserName,
                isExisingUser: isExisingUser,
                viewModel: viewModel))
        interactor.inject(
            .init(
                enterRoomRepository: EnterRoomDataStore(),
                roomRepository: RoomDataStore(roomId: roomId), output: presenter))
        let view = CardListView(
            dependency: .init(
                presenter: presenter,
                roomId: roomId,
                currentUserId: currentUserId,
                cardPackageId: cardPackageId),
            viewModel: viewModel)

        return view
    }

    func assembleSettingModule(roomId: Int, currentUserId: String, cardPackageId: String)
        -> SettingView
    {
        let viewModel = SettingViewModel()
        let presenter = SettingPresenter()
        let interactor = SettingInteractor()

        presenter.inject(.init(useCase: interactor, viewModel: viewModel))
        interactor.inject(
            .init(
                repository: RoomDataStore(roomId: roomId),
                output: presenter,
                currentUserId: currentUserId))
        let view = SettingView(
            dependency: .init(
                presenter: presenter,
                roomId: roomId,
                cardPackageId: cardPackageId),
            viewModel: viewModel)

        return view
    }

    func assembleSelectThemeColorModule(roomId: Int, cardPackageId: String) -> SelectThemeColorView
    {
        let viewModel = SelectThemeColorViewModel()
        let presenter = SelectThemeColorPresenter()
        let interactor = SelectThemeColorInteractor()

        presenter.inject(.init(useCase: interactor, viewModel: viewModel))
        interactor.inject(
            .init(
                repository: RoomDataStore(roomId: roomId),
                output: presenter,
                cardPackageId: cardPackageId))
        let view = SelectThemeColorView(
            dependency: .init(presenter: presenter), viewModel: viewModel)

        return view
    }
}
