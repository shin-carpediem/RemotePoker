extension ModuleAssembler {
    func assmebleEnterRoom() -> EnterRoomView {
        let viewModel = EnterRoomViewModel()
        let presenter = EnterRoomPresenter()
        let interactor = EnterRoomInteractor()
        
        presenter.inject(.init(useCase: interactor, viewModel: viewModel))
        interactor.inject(.init(roomRepository: RoomDataStore(), output: presenter))
        
        let view = EnterRoomView(dependency: .init(presenter: presenter),
                                 viewModel: viewModel)
        
        return view
    }
    
    func assembleCardList(room: Room, currentUser: User) -> CardListView {
        let viewModel = CardListViewModel()
        let presenter = CardListPresenter()
        let interactor = CardListInteractor()
        
        presenter.inject(.init(useCase: interactor,
                               room: room,
                               currentUser: currentUser,
                               viewModel: viewModel))
        interactor.inject(.init(roomRepository: RoomDataStore(roomId: room.id),
                                output: presenter,
                                room: room))

        let view = CardListView(dependency: .init(presenter: presenter,
                                                  room: room,
                                                  currentUser: currentUser),
                                viewModel: viewModel)
        
        return view
    }
    
    func assembleSetting(room: Room, currentUser: User) -> SettingView {
        let viewModel = SettingViewModel()
        let presenter = SettingPresenter()
        let interactor = SettingInteractor()
        
        presenter.inject(.init(useCase: interactor, viewModel: viewModel))
        interactor.inject(.init(roomRepository: RoomDataStore(roomId: room.id),
                                output: presenter,
                                currentUser: currentUser))
        
        let view = SettingView(dependency: .init(presenter: presenter, room: room),
                               viewModel: viewModel)
        
        return view
    }
    
    func assembleSelectThemeColor(room: Room) -> SelectThemeColorView {
        let viewModel = SelectThemeColorViewModel()
        let presenter = SelectThemeColorPresenter()
        let interactor = SelectThemeColorInteractor()
        
        presenter.inject(.init(useCase: interactor,
                               room: room,
                               viewModel: viewModel))
        interactor.inject(.init(roomRepository: RoomDataStore(roomId: room.id),
                                output: presenter,
                                room: room))
        
        let view = SelectThemeColorView(dependency: .init(presenter: presenter),
                                        viewModel: viewModel)
        
        return view
    }
}
