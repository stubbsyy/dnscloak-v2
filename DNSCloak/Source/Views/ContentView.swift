import SwiftUI

struct ContentView: View {
    @StateObject private var settings = Settings()

    var body: some View {
        TabView {
            Text("Home")
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            BlocklistView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Blocklists")
                }

            DNSResolverListView()
                .tabItem {
                    Image(systemName: "server.rack")
                    Text("Resolvers")
                }

            DNSQueryLogView()
                .tabItem {
                    Image(systemName: "text.magnifyingglass")
                    Text("Query Log")
                }
        }
        .environmentObject(settings)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
