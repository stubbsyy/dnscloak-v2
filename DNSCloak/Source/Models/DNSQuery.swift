import Foundation

struct DNSQuery: Codable, Identifiable {
    var id = UUID()
    var domain: String
    var type: String
    var result: String
    var timestamp: Date
}
