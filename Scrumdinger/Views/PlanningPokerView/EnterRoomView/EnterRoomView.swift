import SwiftUI

struct EnterRoomView: View {
    @State var userId: UUID?
    
    // MARK: - Private
    
    @State private var isPresentingNewRoomView = false
    @State private var willNextPagePresenting = false
    @State private var inputText: String = ""
    
    private func registerUser(room: RoomModel) {
        userId = UUID()  // TODO: Modifying state during view update, this will cause undefined behavior.
        if (userId == nil) { return }
        room.addUserToRoom(userId!)
    }
    
    private func createRoomAndRegisterUser() -> RoomModel {
        let room = RoomModel()
        registerUser(room: room)
        return room
    }
    
    // MARK: - View
    
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
//                .fullScreenCover(isPresented: $willNextPagePresenting, content: {
//                    PlanningPokerView(room: createRoomAndRegisterUser())
//                })
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
            PlanningPokerView(room: createRoomAndRegisterUser(), userId: userId)
        })
    }
}

// MARK: - Preview

struct EnterRoomView_Previews: PreviewProvider {
    static var previews: some View {
        EnterRoomView()
    }
}
