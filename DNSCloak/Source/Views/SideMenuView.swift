import SwiftUI

struct SideMenuView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.circle")
                    .imageScale(.large)
                Text("DNSCloak")
                    .font(.headline)
            }
            .padding(.top, 100)

            NavigationLink(destination: ContentView()) {
                HStack {
                    Image(systemName: "house")
                    Text("Home")
                }
            }
            .padding(.top, 30)

            NavigationLink(destination: BlocklistView()) {
                HStack {
                    Image(systemName: "list.bullet")
                    Text("Blocklists")
                }
            }
            .padding(.top, 30)

            NavigationLink(destination: DNSResolverListView()) {
                HStack {
                    Image(systemName: "server.rack")
                    Text("Resolvers")
                }
            }
            .padding(.top, 30)

            NavigationLink(destination: DNSQueryLogView()) {
                HStack {
                    Image(systemName: "text.magnifyingglass")
                    Text("Query Log")
                }
            }
            .padding(.top, 30)

            NavigationLink(destination: SettingsView()) {
                HStack {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            }
            .padding(.top, 30)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.background)
        .foregroundColor(.text)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
    }
}
