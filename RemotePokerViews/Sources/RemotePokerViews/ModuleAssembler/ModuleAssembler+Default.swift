import CardListDomain
import EnterRoomDomain
import RemotePokerData
import RemotePokerDomains
import SelectThemeColorDomain
import SettingDomain
import Shared

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

    public func assembleCardListModule(isExisingUser: Bool
    ) -> CardListView {
        AppConfigManager.appConfig = .init(
            currentUser: .init(id: "0", name: "", selectedCardId: ""),
            currentRoom: .init(id: LocalStorage.shared.currentRoomId, userList: [], cardPackage: .defaultCardPackage)
        )
        
        let viewModel = CardListViewModel()
        let presenter = CardListPresenter()
        let interactor = CardListInteractor()

        var appConfig: AppConfig {
            guard let appConfig = AppConfigManager.appConfig else {
                fatalError()
            }
            return appConfig
        }
        
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
                cardPackageId: appConfig.currentRoom.cardPackage.id),
            viewModel: viewModel)

        return view
    }

    public func assembleSettingModule()
        -> SettingView
    {
        let viewModel = SettingViewModel()
        let presenter = SettingPresenter()
        let interactor = SettingInteractor()

        var appConfig: AppConfig {
            guard let appConfig = AppConfigManager.appConfig else {
                fatalError()
            }
            return appConfig
        }

        presenter.inject(.init(useCase: interactor, viewModel: viewModel))
        interactor.inject(
            .init(
                repository: RoomDataStore(userId: appConfig.currentUser.id, roomId: String(appConfig.currentRoom.id)),
                output: presenter))
        let view = SettingView(
            dependency: SettingView.Dependency(
                presenter: presenter,
                cardPackageId: appConfig.currentRoom.cardPackage.id),
            viewModel: viewModel)

        return view
    }

    public func assembleSelectThemeColorModule()
        -> SelectThemeColorView
    {
        let viewModel = SelectThemeColorViewModel()
        let presenter = SelectThemeColorPresenter()

        var appConfig: AppConfig {
            guard let appConfig = AppConfigManager.appConfig else {
                fatalError()
            }
            return appConfig
        }

        presenter.inject(
            .init(
                repository: RoomDataStore(userId: appConfig.currentUser.id, roomId: String(appConfig.currentRoom.id)),
                viewModel: viewModel,
                cardPackageId: appConfig.currentRoom.cardPackage.id))
        let view = SelectThemeColorView(
            dependency: SelectThemeColorView.Dependency(presenter: presenter), viewModel: viewModel)

        return view
    }
}
