import Foundation

class BlocklistParser {
    func parse(data: Data, format: BlocklistFormat) -> Set<String> {
        switch format {
        case .adblock:
            return parseAdblock(data: data)
        }
    }

    private func parseAdblock(data: Data) -> Set<String> {
        guard let string = String(data: data, encoding: .utf8) else {
            return []
        }
        let lines = string.components(separatedBy: .newlines)
        var domains = Set<String>()
        for line in lines {
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
}

enum BlocklistFormat: Codable {
    case adblock
}
