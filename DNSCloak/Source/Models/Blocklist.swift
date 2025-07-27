import Foundation

struct Blocklist: Codable {
    var name: String
    var url: URL
    var isEnabled: Bool
    var format: BlocklistFormat = .adblock
}
