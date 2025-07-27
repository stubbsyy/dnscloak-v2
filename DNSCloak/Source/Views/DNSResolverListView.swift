import SwiftUI

struct DNSResolverListView: View {
    @EnvironmentObject var settings: Settings
    @State private var showingAddResolver = false

    var body: some View {
        NavigationView {
            ZStack {
                if settings.resolvers.isEmpty {
                    Text(NSLocalizedString("No DNS resolvers.", comment: ""))
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
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
                        .onDelete(perform: delete)
                    }
                }
            }
            .navigationTitle(NSLocalizedString("Resolvers", comment: ""))
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

    func delete(at offsets: IndexSet) {
        settings.resolvers.remove(atOffsets: offsets)
    }
}

struct DNSResolverListView_Previews: PreviewProvider {
    static var previews: some View {
        DNSResolverListView()
    }
}
