import Neumorphic
import SwiftUI

struct EnterRoomView: View, ModuleAssembler {
    // MARK: - Dependency
    
    struct Dependency {
        var presenter: EnterRoomPresenter
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - Private
    
    /// 入力フォーム/名前
    @State private var inputName = ""
    
    /// 入力フォーム/ルームID
    @State private var inputRoomId = ""
    
    /// 入力フォーム/ルームIDの無効を示すアラートを表示するか
    @State private var isShownInputRoomIdInvalidAlert = false
    
    /// 次の画面に遷移するか
    @State private var willPushNextView = false
    
    private var dependency: Dependency
    
    private var isInputRoomIdValid: Bool {
        guard let inputInt = Int(inputRoomId) else { return false }
        return String(inputInt).count == 4
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.Neumorphic.main.ignoresSafeArea()

                VStack(spacing: 28) {
                    HStack(spacing: 14) {
                        TextField("Name",
                                  text: $inputName)
                        .padding()
                        .background(innerShadowBackGround)
                        .tint(.gray)
                        .foregroundColor(.gray)
                        
                        TextField("Room ID",
                                  text: $inputRoomId)
                        .padding()
                        .background(innerShadowBackGround)
                        .tint(.gray)
                        .foregroundColor(.gray)
                    }
                    
                    Button {
                        if !isInputRoomIdValid {
                            isShownInputRoomIdInvalidAlert = true
                        } else {
                            Task {
                                await dependency.presenter.fetchRoomInfo(
                                    inputName: inputName,
                                    inputRoomId: Int(inputRoomId)!)
                                willPushNextView = true
                            }
                        }
                    } label: {
                        Text("Enter")
                            .frame(width: 140, height: 20)
                    }
                    .softButtonStyle(RoundedRectangle(cornerRadius: 20))
                    .padding()
                    
                    NavigationLink(isActive: $willPushNextView, destination: {
                        if willPushNextView {
                            assembleCardList(room: dependency.presenter.room!,
                                             currrentUser: dependency.presenter.currentUser)
                        } else { EmptyView() }
                    }) { EmptyView() }
                }
                .padding(.horizontal, 40)
            }
        }
        .alert("4 Digit Number Required",
               isPresented: $isShownInputRoomIdInvalidAlert,
               actions: {
        }, message: {
            Text("If the number is new, a new room will be created.")
        })
        .navigationTitle("Scrum Dinger")
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
}

// MARK: - Preview

struct EnterRoomView_Previews: PreviewProvider {
    static var previews: some View {
        EnterRoomView(dependency: .init(
            presenter: .init(
                dependency: .init(
                    dataStore: .init()))))
    }
}
