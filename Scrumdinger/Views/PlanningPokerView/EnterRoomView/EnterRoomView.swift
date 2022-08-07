import SwiftUI

struct EnterRoomView: View {
    @State var inputText: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter with Room ID", text: $inputText)
                .fixedSize()
        }
        .navigationTitle("Planning Poker")
    }
}

struct EnterRoomView_Previews: PreviewProvider {
    static var previews: some View {
        EnterRoomView()
    }
}
