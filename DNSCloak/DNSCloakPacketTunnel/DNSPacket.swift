import Foundation

struct DNSPacket {
    static func parseQuery(data: Data) -> String? {
        // This is a simplified implementation. A real implementation would need to parse the DNS packet format.
        // For now, we'll just look for a string that looks like a domain name.
        let string = String(data: data, encoding: .ascii) ?? ""
        let components = string.components(separatedBy: .whitespacesAndNewlines)
        for component in components {
            if component.contains(".") {
                return component
            }
        }
        return nil
    }

    static func blockedResponse(for query: Data) -> Data {
        // This is a simplified implementation. A real implementation would need to construct a valid DNS response.
        // For now, we'll just return a simple string.
        return "BLOCKED".data(using: .ascii)!
    }
}
