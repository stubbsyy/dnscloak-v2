import SwiftUI

struct DNSQueryLogView: View {
    @EnvironmentObject var settings: Settings
    @State private var selectedQuery: DNSQuery?
    @State private var showingActionSheet = false

    var body: some View {
        NavigationView {
            ZStack {
                if settings.queries.isEmpty {
                    Text("No DNS queries yet.")
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
                    List(settings.queries.suffix(100)) { query in
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
                }
            }
            .navigationTitle(NSLocalizedString("Query Log", comment: ""))
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text(NSLocalizedString("Add to...", comment: "")), buttons: [
                    .default(Text(NSLocalizedString("Whitelist", comment: ""))) {
                        if let domain = selectedQuery?.domain {
                            settings.whitelist.insert(domain)
                        }
                    },
                    .default(Text(NSLocalizedString("Blacklist", comment: ""))) {
                        if let domain = selectedQuery?.domain {
                            settings.blacklist.insert(domain)
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
