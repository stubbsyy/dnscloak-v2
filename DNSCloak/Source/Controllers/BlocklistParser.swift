import Foundation

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
