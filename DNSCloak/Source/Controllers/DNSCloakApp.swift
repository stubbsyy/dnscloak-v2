import SwiftUI

@main
struct DNSCloakApp: App {
    private let settings = Settings()
    private let blocklistManager: BlocklistManager

    init() {
        blocklistManager = BlocklistManager(settings: settings)
        blocklistManager.start()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
    }
}
