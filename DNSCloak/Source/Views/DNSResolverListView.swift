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

struct AddDNSResolverView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var address = ""
    @State private var port = 53
    @State private var protocolSelection: DNSProtocol = .standard

    var body: some View {
        NavigationView {
            Form {
                TextField(NSLocalizedString("Name", comment: ""), text: $name)
                TextField(NSLocalizedString("Address", comment: ""), text: $address)
                Stepper(String(format: NSLocalizedString("Port: %d", comment: ""), port), value: $port, in: 1...65535)
                Picker(NSLocalizedString("Protocol", comment: ""), selection: $protocolSelection) {
                    ForEach(DNSProtocol.allCases, id: \.self) { proto in
                        Text(proto.rawValue.uppercased())
                    }
                }
            }
            .navigationTitle(NSLocalizedString("Add DNS Resolver", comment: ""))
            .navigationBarItems(leading: Button(NSLocalizedString("Cancel", comment: "")) {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button(NSLocalizedString("Save", comment: "")) {
                if settings.resolvers.count < 20 {
                    let newResolver = DNSResolver(name: name, address: address, port: port, protocol: protocolSelection)
                    settings.resolvers.append(newResolver)
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}

extension DNSProtocol: CaseIterable {
    public static var allCases: [DNSProtocol] {
        return [.standard, .https, .tls, .quic, .dnscrypt]
    }
}
