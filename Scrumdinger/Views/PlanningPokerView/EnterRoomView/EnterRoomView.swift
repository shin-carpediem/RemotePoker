import SwiftUI

struct EnterRoomView: View {
    // MARK: - Private
    
    @State private var isPresentingNewRoomView = false
    @State private var willNextPagePresenting = false
    @State private var inputText: String = ""
    
    // MARK: - View
    
    var body: some View {
        VStack {
            TextField("Enter with Room ID",
                      text: $inputText,
                      onCommit: {
                inputText = ""
                isPresentingNewRoomView = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    willNextPagePresenting = true
                }
            })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .padding()
                .fixedSize()
                .shadow(radius: 4)
                .fullScreenCover(isPresented: $willNextPagePresenting, content: {
                    PlanningPokerView()
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
            PlanningPokerView()
        })
    }
}

// MARK: - Preview

struct EnterRoomView_Previews: PreviewProvider {
    static var previews: some View {
        EnterRoomView()
    }
}
