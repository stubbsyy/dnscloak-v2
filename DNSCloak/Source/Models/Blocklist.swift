import Foundation

struct Blocklist: Codable {
    var name: String
    var url: URL
    var isEnabled: Bool
    var format: BlocklistFormat

    enum CodingKeys: String, CodingKey {
        case name, url, isEnabled, format
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(URL.self, forKey: .url)
        isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
        format = (try? container.decode(BlocklistFormat.self, forKey: .format)) ?? .adblock
    }
}
