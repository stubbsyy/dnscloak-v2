import SwiftUI

struct DNSQueryLogView: View {
    @EnvironmentObject var settings: Settings
    @State private var selectedQuery: DNSQuery?
    @State private var showingActionSheet = false

    var body: some View {
        NavigationView {
            List(settings.queries) { query in
                Button(action: {
                    selectedQuery = query
                    showingActionSheet = true
                }) {
                    VStack(alignment: .leading) {
                        Text(query.domain).font(.headline)
                        Text(query.result).font(.subheadline)
                    }
                }
            }
            .navigationTitle("DNS Query Log")
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Add to..."), buttons: [
                    .default(Text("Whitelist")) {
                        if let domain = selectedQuery?.domain {
                            settings.whitelist.append(domain)
                        }
                    },
                    .default(Text("Blacklist")) {
                        if let domain = selectedQuery?.domain {
                            settings.blacklist.append(domain)
                        }
                    },
                    .cancel()
                ])
            }
        }
    }
}

struct DNSQueryLogView_Previews: PreviewProvider {
    static var previews: some View {
        DNSQueryLogView()
    }
}
