import SwiftUI

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
                TextField("Name", text: $name)
                TextField("Address", text: $address)
                Stepper("Port: \(port)", value: $port, in: 1...65535)
                Picker("Protocol", selection: $protocolSelection) {
                    ForEach(DNSProtocol.allCases, id: \.self) { proto in
                        Text(proto.rawValue.uppercased())
                    }
                }
            }
            .navigationTitle("Add DNS Resolver")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                let newResolver = DNSResolver(name: name, address: address, port: port, protocol: protocolSelection)
                settings.resolvers.append(newResolver)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

extension DNSProtocol: CaseIterable {
    public static var allCases: [DNSProtocol] {
        return [.standard, .https, .tls, .quic, .dnscrypt]
    }
}

struct AddDNSResolverView_Previews: PreviewProvider {
    static var previews: some View {
        AddDNSResolverView()
    }
}
