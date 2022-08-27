import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct EnterRoomView: View {
    @State var isNewRoom = false
    @State var isRoomExist = false
    @State var existingRoomId = "0"
    @State var usersIdList: [String] = []
    
    // MARK: - Private
    
    @State private var isPresentingNewRoomView = false
    @State private var willNextPagePresenting = false
    @State private var alertMessagePresenting = false
    @State private var inputText = ""
    @State private var errorWrapper: ErrorWrapper?
    
    // 既存Roomがあった場合はRoomIDを返却
    private func checkIsRoomExist(completionHandler: @escaping (Result<Any, Error>) -> ()) {
        let roomCollection = Firestore.firestore().collection("rooms")
        roomCollection.whereField("id", isEqualTo: inputText).getDocuments() { (querySnapshot, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else {
                guard let documents = querySnapshot?.documents else { return }
                if documents.isEmpty {
                    isRoomExist = false
                    alertMessagePresenting = true
                    return
                }
                isRoomExist = true
                if let roomId = querySnapshot?.documents[0].data()["id"] {
                    let roomIdString = roomId as! String
                    existingRoomId = roomIdString
                    if let userIdList = querySnapshot?.documents[0].data()["usersId"] {
                        let usersIdString = userIdList as! [String]
                        usersIdList = usersIdString
                        completionHandler(.success(usersIdString))
                    }
                }
            }
        }
    }
    
    // MARK: - View
    
    var body: some View {
        TextField("Enter with Room ID",
                  text: $inputText,
                  onCommit: {
            checkIsRoomExist { _ in
                if $isRoomExist.wrappedValue {
                    isNewRoom = false
                    isPresentingNewRoomView = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        willNextPagePresenting = true
                    }
                } else {
                    isNewRoom = false
                    alertMessagePresenting = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        alertMessagePresenting = false
                    }
                }
            }
        })
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .multilineTextAlignment(.center)
        .padding()
        .fixedSize()
        .shadow(radius: 4)
        .fullScreenCover(isPresented: $willNextPagePresenting, content: {
            CardListView(isNewRoom: $isNewRoom,
                              existingRoomId: $existingRoomId,
                              usersIdList: $usersIdList)
        })
        .alert(isPresented: $alertMessagePresenting) {
            Alert(title: Text("Room does not exist"))
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
                isNewRoom = true
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
            CardListView(isNewRoom: $isNewRoom,
                              existingRoomId: $existingRoomId,
                              usersIdList: $usersIdList)
        })
    }
}

// MARK: - Preview

struct EnterRoomView_Previews: PreviewProvider {
    static var previews: some View {
        EnterRoomView()
    }
}
