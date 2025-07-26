import SwiftUI

struct BlocklistView: View {
    @EnvironmentObject var settings: Settings
    @State private var showingAddBlocklist = false
    @State private var error: BlocklistError?
    @State private var showError = false
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            ZStack {
                if settings.blocklists.isEmpty {
                    Text("No blocklists.")
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach($settings.blocklists, id: \.name) { $blocklist in
                            Toggle(isOn: $blocklist.isEnabled) {
                                Text(blocklist.name)
                            }
                        }
                    }
                }
                if isLoading {
                    ProgressView()
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
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Error"),
                    message: Text(error?.localizedDescription ?? "An unknown error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct BlocklistView_Previews: PreviewProvider {
    static var previews: some View {
        BlocklistView()
    }
}
