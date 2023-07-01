import CardListDomain
import EnterRoomDomain
import RemotePokerData
import RemotePokerDomains
import SelectThemeColorDomain
import SettingDomain

extension ModuleAssembler {
    public func assmebleEnterRoomModule() -> EnterRoomView {
        let viewModel = EnterRoomViewModel()
        let presenter = EnterRoomPresenter()
        let interactor = EnterRoomInteractor()

        presenter.inject(.init(useCase: interactor, viewModel: viewModel))
        interactor.inject(.init(repository: EnterRoomDataStore(), output: presenter))
        let view = EnterRoomView(
            dependency: EnterRoomView.Dependency(presenter: presenter), viewModel: viewModel)

        return view
    }

    public func assembleCardListModule(
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
            dependency: CardListView.Dependency(
                presenter: presenter,
                roomId: roomId,
                currentUserId: currentUserId,
                cardPackageId: cardPackageId),
            viewModel: viewModel)

        return view
    }

    public func assembleSettingModule(roomId: Int, currentUserId: String, cardPackageId: String)
        -> SettingView
    {
        let viewModel = SettingViewModel()
        let presenter = SettingPresenter()

        presenter.inject(.init(viewModel: viewModel))
        let view = SettingView(
            dependency: SettingView.Dependency(
                presenter: presenter,
                roomId: roomId,
                cardPackageId: cardPackageId),
            viewModel: viewModel)

        return view
    }

    public func assembleSelectThemeColorModule(roomId: Int, cardPackageId: String)
        -> SelectThemeColorView
    {
        let viewModel = SelectThemeColorViewModel()
        let presenter = SelectThemeColorPresenter()

        presenter.inject(
            .init(
                repository: RoomDataStore(roomId: roomId),
                viewModel: viewModel,
                cardPackageId: cardPackageId))
        let view = SelectThemeColorView(
            dependency: SelectThemeColorView.Dependency(presenter: presenter), viewModel: viewModel)

        return view
    }
}
