import SwiftUI

struct EnterRoomView: View {
    @State var userId = UUID()
    @State var roomToEnter = RoomModel()
    
    // MARK: - Private
    
    @State private var isPresentingNewRoomView = false
    @State private var willNextPagePresenting = false
    @State private var inputText: String = ""
    
    private func createRoomAndRegisterUser() {
        roomToEnter.addUserToRoom(userId)
    }
    
    private func registerUserToExistingRoom() {
        roomToEnter.addUserToRoom(userId)
    }
    
    // MARK: - View
    
    var body: some View {
        VStack {
            TextField("Enter with Room ID",
                      text: $inputText,
                      onCommit: {
                inputText = ""
                registerUserToExistingRoom()
            })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .padding()
                .fixedSize()
                .shadow(radius: 4)
                .fullScreenCover(isPresented: $willNextPagePresenting, content: {
                    PlanningPokerView(room: roomToEnter, userId: userId)
                })
        }
        .navigationTitle("Planning Poker")
        .toolbar {
            Button(action: {
                isPresentingNewRoomView = true
            }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $isPresentingNewRoomView) {
            Button(action: {
                createRoomAndRegisterUser()
                isPresentingNewRoomView = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    willNextPagePresenting = true
                }
            }) {
                Text("Create a New Room")
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
        .fullScreenCover(isPresented: $willNextPagePresenting, content: {
            PlanningPokerView(room: roomToEnter, userId: userId)
        })
    }
}

// MARK: - Preview

struct EnterRoomView_Previews: PreviewProvider {
    static var previews: some View {
        EnterRoomView()
    }
}
