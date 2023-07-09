import CardListDomain
import EnterRoomDomain
import RemotePokerData
import RemotePokerDomains
import Shared
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

    public func assembleCardListModule(cardPackageId: String, isExisingUser: Bool
    ) -> CardListView {
        let viewModel = CardListViewModel()
        let presenter = CardListPresenter()
        let interactor = CardListInteractor()

        presenter.inject(
            .init(
                useCase: interactor,
                isExisingUser: isExisingUser,
                viewModel: viewModel))
        interactor.inject(
            .init(
                enterRoomRepository: EnterRoomDataStore(),
                roomRepository: RoomDataStore(userId: appConfig.currentUser.id, roomId: String(appConfig.currentRoom.id)), output: presenter))
        let view = CardListView(
            dependency: CardListView.Dependency(
                presenter: presenter,
                cardPackageId: cardPackageId),
            viewModel: viewModel)

        return view
    }

    public func assembleSettingModule(cardPackageId: String)
        -> SettingView
    {
        let viewModel = SettingViewModel()
        let presenter = SettingPresenter()
        let interactor = SettingInteractor()

        presenter.inject(.init(useCase: interactor, viewModel: viewModel))
        interactor.inject(
            .init(
                repository: RoomDataStore(userId: appConfig.currentUser.id, roomId: String(appConfig.currentRoom.id)),
                output: presenter))
        let view = SettingView(
            dependency: SettingView.Dependency(
                presenter: presenter,
                cardPackageId: cardPackageId),
            viewModel: viewModel)

        return view
    }

    public func assembleSelectThemeColorModule(cardPackageId: String)
        -> SelectThemeColorView
    {
        let viewModel = SelectThemeColorViewModel()
        let presenter = SelectThemeColorPresenter()

        presenter.inject(
            .init(
                repository: RoomDataStore(userId: appConfig.currentUser.id, roomId: String(appConfig.currentRoom.id)),
                viewModel: viewModel,
                cardPackageId: cardPackageId))
        let view = SelectThemeColorView(
            dependency: SelectThemeColorView.Dependency(presenter: presenter), viewModel: viewModel)

        return view
    }
    
    // MARK: - Private
    
    private var appConfig: AppConfig {
        guard let appConfig = AppConfigManager.appConfig else {
            fatalError()
        }
        return appConfig
    }
}
