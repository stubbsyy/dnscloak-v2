import Foundation

enum DNSProtocol: String, Codable {
    case standard
    case https
    case tls
    case quic
    case dnscrypt
}

struct DNSResolver: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var address: String
    var port: Int = 53
    var `protocol`: DNSProtocol
    var isEnabled: Bool = false
}
