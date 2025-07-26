import Foundation

struct DefaultResolvers {
    static let resolvers: [DNSResolver] = [
        DNSResolver(name: "Cloudflare", address: "1.1.1.1", port: 53, protocol: .https, isEnabled: true),
        DNSResolver(name: "Google", address: "8.8.8.8", port: 53, protocol: .https),
        DNSResolver(name: "Quad9", address: "9.9.9.9", port: 53, protocol: .https),
        DNSResolver(name: "AdGuard", address: "94.140.14.14", port: 53, protocol: .https),
        DNSResolver(name: "OpenDNS", address: "208.67.222.222", port: 53, protocol: .https),
    ]
}
