import XCTest
@testable import DNSCloak

class DNSCloakTests: XCTestCase {

    func testBlocklistManager() {
        let settings = Settings()
        let blocklistManager = BlocklistManager(settings: settings)
        let url = URL(string: "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt")!
        let expectation = self.expectation(description: "Fetch blocklist")
        blocklistManager.fetchBlocklist(from: url)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Failed to fetch blocklist: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { domains in
                XCTAssertFalse(domains.isEmpty)
            })
            .store(in: &cancellables)
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testDNSProxy() {
        let settings = Settings()
        settings.combinedBlocklist = ["example.com"]
        let dnsProxy = DNSProxy(settings: settings)
        let query = "example.com".data(using: .ascii)!
        let response = dnsProxy.handlePacket(query)
        XCTAssertNotNil(response)
        XCTAssertEqual(String(data: response!, encoding: .ascii), "BLOCKED")
    }

    private var cancellables = Set<AnyCancellable>()
}
