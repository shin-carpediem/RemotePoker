import FirebaseFirestore
import FirebaseFirestoreSwift
import Neumorphic
import SwiftUI

struct EnterRoomView: View {
    /// 新規のルームか
    @State var isNewRoom = false

    /// ルームが存在するか
    @State var roomExist = false

    /// 存在しているルームのID
    @State var existingRoomId = "0"

    /// ユーザーID一覧
    @State var usersIdList: [String] = []
    
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
                            isShownAlert = true
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
                                 userIdList: $usersIdList)
                })
                .alert(isPresented: $isShownAlert) {
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
                                 userIdList: $usersIdList)
                })
            }
            .padding(.all, 40)
        }
        .navigationTitle("Scrum Dinger")
    }
    
    // MARK: - Private
    
    /// 新規のルームViewか
    @State private var isNewRoomView = false
    
    /// 次のページに遷移するか
    @State private var willNextPage = false
    
    /// アラートを表示するか
    @State private var isShownAlert = false
    
    /// 入力テキスト
    @State private var inputText = ""
    
    /// エラーラッパー
    @State private var errorWrapper: ErrorWrapper?
    
    private func checkRoomExist(completionHandler: @escaping (Result<Any, Error>) -> ()) {
        let roomCollection = Firestore.firestore().collection("rooms")
        roomCollection.whereField("id", isEqualTo: inputText).getDocuments() { (querySnapshot, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else {
                guard let documents = querySnapshot?.documents else { return }
                if documents.isEmpty {
                    isShownAlert = true
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
}

// MARK: - Preview

struct EnterRoomView_Previews: PreviewProvider {
    static var previews: some View {
        EnterRoomView()
    }
}
