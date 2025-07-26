import Foundation
import Network

class DNSProxy {
    private let settings: Settings
    private var connection: NWConnection?

    init(settings: Settings) {
        self.settings = settings
    }

    func handlePacket(_ packet: Data) -> Data? {
        guard let domain = DNSPacket.parseQuery(data: packet) else {
            return nil
        }

        if settings.whitelist.contains(domain) {
            forwardQuery(data: packet)
            return nil
        }

        if settings.blacklist.contains(domain) {
            return DNSPacket.blockedResponse(for: packet)
        }

        if settings.combinedBlocklist.contains(domain) {
            return DNSPacket.blockedResponse(for: packet)
        } else {
            forwardQuery(data: packet)
            return nil
        }
    }

    private func forwardQuery(data: Data) {
        let resolver = settings.resolvers.first { $0.isEnabled } ?? DNSResolver(name: "Cloudflare", address: "1.1.1.1", protocol: .https)

        switch resolver.protocol {
        case .https:
            forwardQueryHTTPS(data: data, resolver: resolver)
        case .tls:
            forwardQueryTLS(data: data, resolver: resolver)
        case .quic:
            forwardQueryQuic(data: data, resolver: resolver)
        case .dnscrypt:
            forwardQueryDNSCrypt(data: data, resolver: resolver)
        default:
            break
        }
    }

    private func forwardQueryHTTPS(data: Data, resolver: DNSResolver) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = resolver.address
        urlComponents.path = "/dns-query"
        urlComponents.queryItems = [URLQueryItem(name: "dns", value: data.base64EncodedString())]

        guard let url = urlComponents.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/dns-message", forHTTPHeaderField: "accept")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Handle response
        }.resume()
    }

    private func forwardQueryTLS(data: Data, resolver: DNSResolver) {
        let host = NWEndpoint.Host(resolver.address)
        let port = NWEndpoint.Port(rawValue: UInt16(resolver.port))!
        let connection = NWConnection(host: host, port: port, using: .tls)

        connection.stateUpdateHandler = { state in
            switch state {
            case .ready:
                connection.send(content: data, completion: .contentProcessed({ error in
                    if error != nil {
                        connection.cancel()
                    }
                }))
                connection.receive(minimumIncompleteLength: 1, maximumLength: 65535) { (data, context, isComplete, error) in
                    // Handle response
                    connection.cancel()
                }
            case .failed:
                connection.cancel()
            default:
                break
            }
        }
        connection.start(queue: .global())
    }

    private func forwardQueryQuic(data: Data, resolver: DNSResolver) {
        // Implementation using SwiftQuic library
    }

    private func forwardQueryDNSCrypt(data: Data, resolver: DNSResolver) {
        // Implementation using DNSCrypt library
    }
}
