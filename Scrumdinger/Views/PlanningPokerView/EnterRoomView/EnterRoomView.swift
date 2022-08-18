import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct EnterRoomView: View {
    // MARK: - Private
    
    @State private var isPresentingNewRoomView = false
    @State private var willNextPagePresenting = false
    @State private var alertMessagePresenting = false
    @State private var isNewRoom = false
    @State private var inputText: String = ""
    
    private func isRoomExist() -> Bool {
        var isRoomExist = false
        let roomCollection = Firestore.firestore().collection("rooms")
        roomCollection.whereField("id", isEqualTo: $inputText).getDocuments() { (querySnapshot, error) in
            if error == nil {
                isRoomExist = true
            }
        }
        return isRoomExist
    }
    
    // MARK: - View
    
    var body: some View {
        VStack {
            TextField("Enter with Room ID",
                      text: $inputText,
                      onCommit: {
                inputText = ""
                isNewRoom = false
                if isRoomExist() {
                    isPresentingNewRoomView = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        willNextPagePresenting = true
                    }
                } else {
                    alertMessagePresenting = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        alertMessagePresenting = false
                    }
                }
            })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .padding()
                .fixedSize()
                .shadow(radius: 4)
                .fullScreenCover(isPresented: $willNextPagePresenting, content: {
                    PlanningPokerView(isNewRoom: false)
                })
                .alert(isPresented: $alertMessagePresenting) {
                    Alert(title: Text("Room does not exist"))
                }
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
                isNewRoom = true
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
            PlanningPokerView(isNewRoom: true)
        })
    }
}

// MARK: - Preview

struct EnterRoomView_Previews: PreviewProvider {
    static var previews: some View {
        EnterRoomView()
    }
}
