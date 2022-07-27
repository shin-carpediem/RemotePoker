import SwiftUI

struct IndexView: View {
    @Binding var scrums: [DailyScrum]
    let saveAction: () -> Void

    var body: some View {
        TabView {
            VelocitiesView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.3")
                        Text("Velocity")
                    }
                }.tag(1)
            ScrumsView(scrums: $scrums, saveAction: saveAction)
                .tabItem {
                    VStack {
                        Image(systemName: "timer")
                        Text("Scrum")
                    }
                }.tag(2)
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
