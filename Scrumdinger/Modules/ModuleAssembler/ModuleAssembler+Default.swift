extension ModuleAssembler {
    func assmebleEnterRoom() -> EnterRoomView {
        let viewModel = EnterRoomViewModel()
        let presenter = EnterRoomPresenter()
        let interactor = EnterRoomInteractor()

        presenter.inject(.init(useCase: interactor, viewModel: viewModel))
        interactor.inject(.init(roomRepository: RoomDataStore(), output: presenter))

        let view = EnterRoomView(dependency: .init(presenter: presenter), viewModel: viewModel)

        return view
    }

    func assembleCardList(
        roomId: Int, currentUserId: String, currentUserName: String, cardPackageId: String
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
                viewModel: viewModel))
        interactor.inject(.init(roomRepository: RoomDataStore(roomId: roomId), output: presenter))

        let view = CardListView(
            dependency: .init(
                presenter: presenter,
                roomId: roomId,
                currentUserId: currentUserId,
                cardPackageId: cardPackageId),
            viewModel: viewModel)

        return view
    }

    func assembleSetting(roomId: Int, currentUserId: String, cardPackageId: String) -> SettingView {
        let viewModel = SettingViewModel()
        let presenter = SettingPresenter()
        let interactor = SettingInteractor()

        presenter.inject(.init(useCase: interactor, viewModel: viewModel))
        interactor.inject(
            .init(
                roomRepository: RoomDataStore(roomId: roomId),
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

    func assembleSelectThemeColor(roomId: Int, cardPackageId: String) -> SelectThemeColorView {
        let viewModel = SelectThemeColorViewModel()
        let presenter = SelectThemeColorPresenter()
        let interactor = SelectThemeColorInteractor()

        presenter.inject(.init(useCase: interactor, viewModel: viewModel))
        interactor.inject(
            .init(
                roomRepository: RoomDataStore(roomId: roomId),
                output: presenter,
                cardPackageId: cardPackageId))

        let view = SelectThemeColorView(
            dependency: .init(presenter: presenter), viewModel: viewModel)

        return view
    }
}
