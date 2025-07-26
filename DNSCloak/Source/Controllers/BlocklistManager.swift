import Foundation
import Combine

class BlocklistManager {
    private var settings: Settings
    private var cancellables = Set<AnyCancellable>()

    init(settings: Settings) {
        self.settings = settings
    }

    func fetchBlocklist(from url: URL) -> AnyPublisher<[String], BlocklistError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .mapError { BlocklistError.networkError($0) }
            .map(\.data)
            .tryMap { data in
                guard let string = String(data: data, encoding: .utf8) else {
                    throw BlocklistError.invalidData
                }
                return string.components(separatedBy: .newlines)
                    .filter { !$0.starts(with: "#") && !$0.isEmpty }
            }
            .mapError { $0 as? BlocklistError ?? .parsingError }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func updateBlocklists() {
        let publishers = settings.blocklists
            .filter { $0.isEnabled }
            .map { fetchBlocklist(from: $0.url) }

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

    private func combineBlocklists(domains: [[String]]) -> [String] {
        let combined = domains.flatMap { $0 }
        return Array(Set(combined))
    }
}
