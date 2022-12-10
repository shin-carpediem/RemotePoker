import Neumorphic
import SwiftUI

struct EnterRoomView: View, ModuleAssembler {
    // MARK: - Dependency
    
    struct Dependency {
        var presenter: EnterRoomPresenter
    }
    
    init(dependency: Dependency, viewModel: EnterRoomViewModel) {
        self.dependency = dependency
        self.viewModel = viewModel
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    @ObservedObject private var viewModel: EnterRoomViewModel
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.Neumorphic.main.ignoresSafeArea()
                VStack(spacing: 28) {
                    inputField
                    sendButton
                }
                .padding(.horizontal, 40)
                // TODO: インジケーターがうまく作用しない
                // viewModel.activityIndicator.body
                navigationForCardListView
            }
        }
        .alert(isPresented: $viewModel.isShownLoginAsCurrentUserAlert, content: {
            Alert(title: Text("Enter Existing Room?"),
                  primaryButton: .default(Text("OK"), action: {
                Task {
                    await dependency.presenter.didTapEnterExistingRoomButton()
                }
            }),
                  secondaryButton: .cancel())
        })
        .alert("Name & 4 Digit Number Required",
               isPresented: $viewModel.isShownInputFormInvalidAlert,
               actions: {},
               message: {
            Text("If the number is new, a new room will be created.")
        })
        .navigationTitle("Scrum Dinger")
        .onAppear {
            if AppConfig.shared.isCurrentUserLoggedIn {
                dependency.presenter.outputLoginAsCurrentUserAlert()
            }
        }
    }
    
    private var inputField: some View {
        HStack(spacing: 14) {
            TextField("Name",
                      text: $viewModel.inputName)
            .padding()
            .background(innerShadowBackGround)
            .tint(.gray)
            .foregroundColor(.gray)
            
            TextField("Room ID",
                      text: $viewModel.inputRoomId)
            .padding()
            .background(innerShadowBackGround)
            .tint(.gray)
            .foregroundColor(.gray)
        }
    }
    
    private var sendButton: some View {
        Button {
            if !dependency.presenter.isInputFormValid() {
                dependency.presenter.outputInputInvalidAlert()
            } else {
                Task {
                    await dependency.presenter.didTapEnterRoomButton(
                        userName: viewModel.inputName,
                        roomId: Int(viewModel.inputRoomId)!)
                }
            }
        } label: {
            Text("Enter")
                .frame(width: 140, height: 20)
        }
        .softButtonStyle(RoundedRectangle(cornerRadius: 20))
        .padding()
        .disabled(!viewModel.isButtonAbled)
    }
    
    private var innerShadowBackGround: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.Neumorphic.main)
            .softInnerShadow(RoundedRectangle(cornerRadius: 20),
                             darkShadow: Color.Neumorphic.darkShadow,
                             lightShadow: Color.Neumorphic.lightShadow,
                             spread: 0.2,
                             radius: 2)
    }
    
    // MARK: - Router
    
    private var navigationForCardListView: some View {
        NavigationLink(isActive: $viewModel.willPushCardListView, destination: {
            if viewModel.willPushCardListView {
                assembleCardList(room: dependency.presenter.room!,
                                 currrentUser: dependency.presenter.currentUser)
            } else { EmptyView() }
        }) { EmptyView() }
    }
}

// MARK: - Preview

struct EnterRoomView_Previews: PreviewProvider {
    static var previews: some View {
        EnterRoomView(dependency: .init(
            presenter: .init(
                dependency: .init(
                    dataStore: .init(),
                    viewModel: .init()))),
                      viewModel: .init())
    }
}
