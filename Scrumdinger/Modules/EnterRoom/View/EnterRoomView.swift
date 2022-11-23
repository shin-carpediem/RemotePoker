import Neumorphic
import SwiftUI

struct EnterRoomView: View {
    var body: some View {
        ZStack {
            Color.Neumorphic.main.ignoresSafeArea()

            VStack {
                TextField("Enter with Room ID ...",
                          value: $inputNumber,
                          format: .number)
                .onSubmit {
                    if !isInputNumberValid {
                        isShownInputInvalidAlert = true
                    } else {
                        Task {
                            await presenter.fetchRoomInfo(inputNumber: inputNumber)
                            willPresentModal = true
                        }
                    }
                }
                .fullScreenCover(isPresented: $willPresentModal) {
                    CardListView(room: presenter.room!,
                                 currentUserId: presenter.currentUserId)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.Neumorphic.main)
                        .softInnerShadow(RoundedRectangle(cornerRadius: 20),
                                         darkShadow: Color.Neumorphic.darkShadow,
                                         lightShadow: Color.Neumorphic.lightShadow,
                                         spread: 0.2,
                                         radius: 2)
                )
            }
            .padding(.all, 40)
        }
        .alert("4 Digit Number Required",
               isPresented: $isShownInputInvalidAlert,
               actions: {
        }, message: {
            Text("If the number is new, a new room will be created.")
        })
        .navigationTitle("Scrum Dinger")
    }
    
    // MARK: - Private
    
    /// 入力ナンバー
    @State private var inputNumber = 0
    
    /// 入力ナンバーの無効を示すアラートを表示するか
    @State private var isShownInputInvalidAlert = false
    
    /// モーダルを表示するか
    @State private var willPresentModal = false
    
    private let presenter = EnterRoomPresenter()
    
    private var isInputNumberValid: Bool {
        String(inputNumber).count == 4
    }
}

// MARK: - Preview

struct EnterRoomView_Previews: PreviewProvider {
    static var previews: some View {
        EnterRoomView()
    }
}
