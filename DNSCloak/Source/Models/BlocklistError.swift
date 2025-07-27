import Foundation

enum BlocklistError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidData
    case parsingError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The provided URL is invalid."
        case .networkError(let error):
            return "A network error occurred: \(error.localizedDescription)"
        case .invalidData:
            return "The data received from the server was invalid."
        case .parsingError:
            return "An error occurred while parsing the blocklist."
        }
    }
}
