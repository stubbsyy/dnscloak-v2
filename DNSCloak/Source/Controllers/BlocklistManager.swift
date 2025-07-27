import Foundation
import Combine

class BlocklistParser {
    func detectFormat(data: Data) -> BlocklistFormat {
        // This is a simplified implementation. A real implementation would need to be more sophisticated.
        let string = String(data: data, encoding: .utf8) ?? ""
        if string.contains("! Title:") && string.contains("! Version:") {
            return .adblock
        }
        if string.contains("127.0.0.1") || string.contains("0.0.0.0") {
            return .hosts
        }
        return .adblock // Default to adblock
    }

    func parse(data: Data, format: BlocklistFormat, limit: Int = 500000) -> Set<String> {
        switch format {
        case .adblock:
            return parseAdblock(data: data, limit: limit)
        case .hosts:
            return parseHosts(data: data, limit: limit)
        }
    }

    private func parseAdblock(data: Data, limit: Int) -> Set<String> {
        guard let string = String(data: data, encoding: .utf8) else {
            return []
        }
        let lines = string.components(separatedBy: .newlines)
        var domains = Set<String>()
        for line in lines {
            if domains.count >= limit { break }
            if line.starts(with: "||") && line.hasSuffix("^") {
                let start = line.index(line.startIndex, offsetBy: 2)
                let end = line.index(line.endIndex, offsetBy: -1)
                let domain = String(line[start..<end])
                domains.insert(domain)
            } else if !line.starts(with: "!") && !line.starts(with: "#") && !line.contains("/") {
                domains.insert(line)
            }
        }
        return domains
    }

    private func parseHosts(data: Data, limit: Int) -> Set<String> {
        guard let string = String(data: data, encoding: .utf8) else {
            return []
        }
        let lines = string.components(separatedBy: .newlines)
        var domains = Set<String>()
        for line in lines {
            if domains.count >= limit { break }
            if line.starts(with: "0.0.0.0") || line.starts(with: "127.0.0.1") {
                let components = line.components(separatedBy: .whitespacesAndNewlines)
                if components.count > 1 {
                    domains.insert(components[1])
                }
            }
        }
        return domains
    }
}

enum BlocklistFormat: Codable {
    case adblock
    case hosts
}

class BlocklistManager {
    private var settings: Settings
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?

    init(settings: Settings) {
        self.settings = settings
    }

    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(settings.updateInterval.rawValue), repeats: true) { [weak self] _ in
            self?.updateBlocklists()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private let parser = BlocklistParser()

    func fetchBlocklist(from blocklist: Blocklist) -> AnyPublisher<Set<String>, BlocklistError> {
        URLSession.shared.dataTaskPublisher(for: blocklist.url)
            .mapError { BlocklistError.networkError($0) }
            .map(\.data)
            .map { [weak self] data in
                guard let self = self else { return [] }
                let format = self.parser.detectFormat(data: data)
                return self.parser.parse(data: data, format: format, limit: self.settings.blocklistLimit)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func updateBlocklists() {
        let publishers = settings.blocklists
            .filter { $0.isEnabled }
            .map { fetchBlocklist(from: $0) }

        Publishers.MergeMany(publishers)
            .collect()
            .map { self.combineBlocklists(domains: $0) }
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    // Present the error to the user
                    print("Error updating blocklists: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] combined in
                self?.settings.combinedBlocklist = combined
            })
            .store(in: &cancellables)
    }

    private func combineBlocklists(domains: [Set<String>]) -> Set<String> {
        return domains.reduce(Set<String>()) { (result, set) in
            result.union(set)
        }
    }
}
