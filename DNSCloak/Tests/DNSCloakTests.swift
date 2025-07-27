import XCTest
@testable import DNSCloak

class DNSCloakTests: XCTestCase {

    func testBlocklistManager() {
        let settings = Settings()
        let blocklistManager = BlocklistManager(settings: settings)
        var url = URL(string: "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt")!
        var expectation = self.expectation(description: "Fetch blocklist")
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

        url = URL(string: "https://invalid-url")!
        expectation = self.expectation(description: "Fetch blocklist with error")
        blocklistManager.fetchBlocklist(from: url)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, .invalidURL)
                } else {
                    XCTFail("Expected an error")
                }
                expectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testDNSProxy() {
        let settings = Settings()
        settings.combinedBlocklist = ["example.com"]
        let dnsProxy = DNSProxy(settings: settings)
        var query = "example.com".data(using: .ascii)!
        var response = dnsProxy.handlePacket(query)
        XCTAssertNotNil(response)
        XCTAssertEqual(String(data: response!, encoding: .ascii), "BLOCKED")

        settings.whitelist = ["example.com"]
        response = dnsProxy.handlePacket(query)
        XCTAssertNil(response)

        settings.whitelist = []
        settings.blacklist = ["google.com"]
        query = "google.com".data(using: .ascii)!
        response = dnsProxy.handlePacket(query)
        XCTAssertNotNil(response)
        XCTAssertEqual(String(data: response!, encoding: .ascii), "BLOCKED")
    }

    func testSettings() {
        let settings = Settings(appGroup: "group.com.example.DNSCloak.tests")
        settings.blocklists = [Blocklist(name: "Test Blocklist", url: URL(string: "https://example.com")!, isEnabled: true)]
        settings.resolvers = [DNSResolver(name: "Test Resolver", address: "8.8.8.8", protocol: .standard)]
        settings.whitelist = ["example.com"]
        settings.blacklist = ["google.com"]

        let newSettings = Settings(appGroup: "group.com.example.DNSCloak.tests")
        XCTAssertEqual(newSettings.blocklists.count, 1)
        XCTAssertEqual(newSettings.resolvers.count, 1)
        XCTAssertEqual(newSettings.whitelist.count, 1)
        XCTAssertEqual(newSettings.blacklist.count, 1)
    }

    private var cancellables = Set<AnyCancellable>()
}
