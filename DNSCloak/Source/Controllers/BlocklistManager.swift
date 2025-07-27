import Foundation
import Combine

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
