import SwiftUI

struct IndexView: View {
    // MARK: - Private
    
    @StateObject private var store = ScrumStore()
    @State private var errorWrapper: ErrorWrapper?

    // MARK: - Body
    
    var body: some View {
        TabView {
            NavigationView {
                EnterRoomView()
            }
            .tabItem {
                VStack {
                    Image(systemName: "lanyardcard")
                    Text("Planning Poker")
                }
            }
            .tag(1)
            NavigationView {
                ScrumsView(scrums: $store.scrums) {
                    Task {
                        do {
                            // discardableResultsave属性を関数に付したので、戻り値は無視できる。
                            try await ScrumStore.save(scrums: store.scrums)
                        } catch {
                            errorWrapper = ErrorWrapper(error: error, guidance: "Try again later.")
                        }
                    }
                }
            }
            .task {
                do {
                    store.scrums = try await ScrumStore.load()
                } catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "Scrumdinger will load sample data and continue.")
                }
            }
            .sheet(item: $errorWrapper, onDismiss: {
                store.scrums = DailyScrum.sampleData
            }) { wrapper in
                ErrorView(errorWrapper: wrapper)
            }
            .tabItem {
                VStack {
                    Image(systemName: "timer")
                    Text("Scrum Meeting")
                }
            }
            .tag(2)
        }
    }
}

struct IndexView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrumsView(scrums: .constant(DailyScrum.sampleData), saveAction: {})
        }
    }
}
