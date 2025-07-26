import SwiftUI

struct DNSResolverListView: View {
    @EnvironmentObject var settings: Settings
    @State private var showingAddResolver = false

    var body: some View {
        NavigationView {
            List {
                ForEach(settings.resolvers) { resolver in
                    Button(action: {
                        // Select this resolver
                    }) {
                        HStack {
                            Text(resolver.name)
                            Spacer()
                            if resolver.isEnabled {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            .navigationTitle("DNS Resolvers")
            .navigationBarItems(trailing: Button(action: {
                showingAddResolver = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddResolver) {
                AddDNSResolverView()
            }
        }
    }
}

struct DNSResolverListView_Previews: PreviewProvider {
    static var previews: some View {
        DNSResolverListView()
    }
}
