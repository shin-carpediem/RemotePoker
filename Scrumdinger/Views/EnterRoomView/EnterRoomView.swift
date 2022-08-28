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
    
    @State private var isNewRoomView = false
    @State private var willNextPage = false
    @State private var isAlertMessage = false
    @State private var inputText = ""
    @State private var errorWrapper: ErrorWrapper?
    
    private func checkRoomExist(completionHandler: @escaping (Result<Any, Error>) -> ()) {
        let roomCollection = Firestore.firestore().collection("rooms")
        roomCollection.whereField("id", isEqualTo: inputText).getDocuments() { (querySnapshot, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else {
                guard let documents = querySnapshot?.documents else { return }
                if documents.isEmpty {
                    isAlertMessage = true
                    return
                }
                roomExist = true
                guard let data = querySnapshot?.documents[0].data() else { return }
                existingRoomId = data["id"] as! String
                usersIdList = data["usersId"] as! [String]
                completionHandler(.success(usersIdList))
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
                    checkRoomExist { _ in
                        isNewRoom = false
                        if $roomExist.wrappedValue {
                            isNewRoomView = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                willNextPage = true
                            }
                        } else {
                            isAlertMessage = true
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
                .fullScreenCover(isPresented: $willNextPage,
                                 content: {
                    CardListView(isNewRoom: $isNewRoom,
                                      existingRoomId: $existingRoomId,
                                      usersIdList: $usersIdList)
                })
                .alert(isPresented: $isAlertMessage) {
                    Alert(title: Text("Room does not exist"))
                }
                
                Button(action: {
                    isNewRoomView = true
                }) {
                    Image(systemName: "plus")
                }
                .softButtonStyle(Circle())
                .padding(.top, 20)
                .sheet(isPresented: $isNewRoomView) {
                    ZStack {
                        Color.Neumorphic.main.ignoresSafeArea()
                        Button(action: {
                            isNewRoom = true
                            isNewRoomView = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                willNextPage = true
                            }
                        }) {
                            Text("Create a New Room")
                                .fontWeight(.bold)
                        }
                        .softButtonStyle(RoundedRectangle(cornerRadius: 20))
                    }
                }
                .fullScreenCover(isPresented: $willNextPage,
                                 content: {
                    CardListView(isNewRoom: $isNewRoom,
                                      existingRoomId: $existingRoomId,
                                      usersIdList: $usersIdList)
                })
            }
            .padding(.all, 40)
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
