import Foundation
import Combine

class BlocklistManager {
    private var settings: Settings
    private var cancellables = Set<AnyCancellable>()

    init(settings: Settings) {
        self.settings = settings
    }

    func fetchBlocklist(from url: URL) -> AnyPublisher<[String], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .map { data -> [String] in
                guard let string = String(data: data, encoding: .utf8) else { return [] }
                return string.components(separatedBy: .newlines)
                    .filter { !$0.starts(with: "#") && !$0.isEmpty }
            }
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
                    print("Error updating blocklists: \(error)")
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
