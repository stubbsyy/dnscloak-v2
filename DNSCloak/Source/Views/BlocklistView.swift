import SwiftUI

struct BlocklistView: View {
    @EnvironmentObject var settings: Settings
    @State private var showingAddBlocklist = false

    var body: some View {
        NavigationView {
            List {
                ForEach($settings.blocklists, id: \.name) { $blocklist in
                    Toggle(isOn: $blocklist.isEnabled) {
                        Text(blocklist.name)
                    }
                }
            }
            .navigationTitle("Blocklists")
            .navigationBarItems(trailing: Button(action: {
                showingAddBlocklist = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddBlocklist) {
                AddBlocklistView()
            }
        }
    }
}

struct BlocklistView_Previews: PreviewProvider {
    static var previews: some View {
        BlocklistView()
    }
}
