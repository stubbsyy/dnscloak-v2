import Foundation

enum UpdateInterval: Int, Codable, CaseIterable {
    case daily = 86400
    case weekly = 604800

    var localizedDescription: String {
        switch self {
        case .daily:
            return "Every 24 hours"
        case .weekly:
            return "Every week"
        }
    }
}

class Settings: ObservableObject {
    @Published var blocklists: [Blocklist] = [] {
        didSet { saveSettings() }
    }
    @Published var resolvers: [DNSResolver] = [] {
        didSet { saveSettings() }
    }
    @Published var queries: [DNSQuery] = [] {
        didSet { saveSettings() }
    }
    @Published var combinedBlocklist: Set<String> = [] {
        didSet { saveSettings() }
    }
    @Published var whitelist: Set<String> = [] {
        didSet { saveSettings() }
    }
    @Published var blacklist: Set<String> = [] {
        didSet { saveSettings() }
    }
    @Published var updateInterval: UpdateInterval = .daily {
        didSet { saveSettings() }
    }
    @Published var blocklistLimit: Int = 500000 {
        didSet { saveSettings() }
    }

    private let userDefaults: UserDefaults

    init(appGroup: String = "group.com.example.DNSCloak") {
        self.userDefaults = UserDefaults(suiteName: appGroup)!
        loadSettings()
    }

    func saveSettings() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(blocklists) {
            userDefaults.set(encoded, forKey: "blocklists")
        }
        if let encoded = try? encoder.encode(resolvers) {
            userDefaults.set(encoded, forKey: "resolvers")
        }
        if let encoded = try? encoder.encode(queries) {
            userDefaults.set(encoded, forKey: "queries")
        }
        if let encoded = try? encoder.encode(Array(combinedBlocklist)) {
            userDefaults.set(encoded, forKey: "combinedBlocklist")
        }
        if let encoded = try? encoder.encode(Array(whitelist)) {
            userDefaults.set(encoded, forKey: "whitelist")
        }
        if let encoded = try? encoder.encode(Array(blacklist)) {
            userDefaults.set(encoded, forKey: "blacklist")
        }
        if let encoded = try? encoder.encode(updateInterval) {
            userDefaults.set(encoded, forKey: "updateInterval")
        }
        if let encoded = try? encoder.encode(blocklistLimit) {
            userDefaults.set(encoded, forKey: "blocklistLimit")
        }
    }

    func loadSettings() {
        let decoder = JSONDecoder()
        if let data = userDefaults.data(forKey: "blocklists"),
           let decoded = try? decoder.decode([Blocklist].self, from: data) {
            blocklists = decoded
        }
        if let data = userDefaults.data(forKey: "resolvers"),
           let decoded = try? decoder.decode([DNSResolver].self, from: data) {
            resolvers = decoded
        }
        if let data = userDefaults.data(forKey: "queries"),
           let decoded = try? decoder.decode([DNSQuery].self, from: data) {
            queries = decoded
        }
        if let data = userDefaults.data(forKey: "combinedBlocklist"),
           let decoded = try? decoder.decode([String].self, from: data) {
            combinedBlocklist = Set(decoded)
        }
        if let data = userDefaults.data(forKey: "whitelist"),
           let decoded = try? decoder.decode([String].self, from: data) {
            whitelist = Set(decoded)
        }
        if let data = userDefaults.data(forKey: "blacklist"),
           let decoded = try? decoder.decode([String].self, from: data) {
            blacklist = Set(decoded)
        }
        if let data = userDefaults.data(forKey: "updateInterval"),
           let decoded = try? decoder.decode(UpdateInterval.self, from: data) {
            updateInterval = decoded
        }
        if let data = userDefaults.data(forKey: "blocklistLimit"),
           let decoded = try? decoder.decode(Int.self, from: data) {
            blocklistLimit = decoded
        }
    }
}
