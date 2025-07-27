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
