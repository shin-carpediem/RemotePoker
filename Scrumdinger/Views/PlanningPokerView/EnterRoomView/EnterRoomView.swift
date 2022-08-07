import SwiftUI

struct EnterRoomView: View {
    @State private var isPresentingNewRoomView = false
    @State private var inputText: String = ""
        
    private func RegisterUser(room: RoomModel) {
        room.addUserToRoom(UUID())
    }
    
    private func createRoomAndRegisterUser() -> RoomModel {
        let room = RoomModel()
        RegisterUser(room: room)
        return room
    }
    
    var body: some View {
        VStack {
            TextField("Enter with Room ID",
                      text: $inputText,
                      onCommit: {
                self.inputText = ""
            })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .padding()
                .fixedSize()
                .shadow(radius: 4)
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
            // TODO: PlanningPokerView()に遷移していない
            NavigationLink(destination: PlanningPokerView(room: createRoomAndRegisterUser())) {
                Button(action: {
                    isPresentingNewRoomView = false
                }) {
                    Text("Create a New Room")
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

struct EnterRoomView_Previews: PreviewProvider {
    static var previews: some View {
        EnterRoomView()
    }
}
