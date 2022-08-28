import FirebaseFirestore
import FirebaseFirestoreSwift
import Neumorphic
import SwiftUI

struct EnterRoomView: View {
    @State var isNewRoom = false
    @State var roomExist = false
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
                    roomExist = false
                    alertMessagePresenting = true
                    return
                }
                roomExist = true
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
        ZStack {
            Color.Neumorphic.main.ignoresSafeArea()

            VStack {
                TextField("Enter with Room ID ...",
                          text: $inputText,
                          onCommit: {
                    checkIsRoomExist { _ in
                        if $roomExist.wrappedValue {
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
                .fullScreenCover(isPresented: $willNextPagePresenting,
                                 content: {
                    CardListView(isNewRoom: $isNewRoom,
                                      existingRoomId: $existingRoomId,
                                      usersIdList: $usersIdList)
                })
                .alert(isPresented: $alertMessagePresenting) {
                    Alert(title: Text("Room does not exist"))
                }
                
                Button(action: {
                    isPresentingNewRoomView = true
                }) {
                    Image(systemName: "plus")
                }
                .softButtonStyle(Circle())
                .sheet(isPresented: $isPresentingNewRoomView) {
                    ZStack {
                        Color.Neumorphic.main.ignoresSafeArea()
                        Button(action: {
                            isNewRoom = true
                            isPresentingNewRoomView = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                willNextPagePresenting = true
                            }
                        }) {
                            Text("Create a New Room")
                                .fontWeight(.bold)
                        }
                        .softButtonStyle(RoundedRectangle(cornerRadius: 20))
                    }
                }
                .fullScreenCover(isPresented: $willNextPagePresenting,
                                 content: {
                    CardListView(isNewRoom: $isNewRoom,
                                      existingRoomId: $existingRoomId,
                                      usersIdList: $usersIdList)
                })
            }
            .padding().padding()
        }
        .navigationTitle("Planning Poker")
    }
}

// MARK: - Preview

struct EnterRoomView_Previews: PreviewProvider {
    static var previews: some View {
        EnterRoomView()
    }
}
