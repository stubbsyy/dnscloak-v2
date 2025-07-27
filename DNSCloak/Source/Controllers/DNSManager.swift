import Foundation
import NetworkExtension
import Combine
import Intents

class DNSManager: ObservableObject {
    @Published var vpnStatus: NEVPNStatus = .invalid
    private var cancellables = Set<AnyCancellable>()

    init() {
        NotificationCenter.default.publisher(for: .NEVPNStatusDidChange)
            .map { notification -> NEVPNStatus in
                guard let connection = notification.object as? NEVPNConnection else { return .invalid }
                return connection.status
            }
            .assign(to: \.vpnStatus, on: self)
            .store(in: &cancellables)

        $vpnStatus
            .filter { $0 == .disconnected || $0 == .invalid }
            .sink { [weak self] _ in
                self?.startVPN()
            }
            .store(in: &cancellables)
    }

    func startVPN() {
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
            guard let managers = managers, error == nil else {
                return
            }

            let manager: NETunnelProviderManager
            if managers.isEmpty {
                manager = NETunnelProviderManager()
                manager.protocolConfiguration = NETunnelProviderProtocol()
                manager.localizedDescription = "DNSCloak"
                manager.isEnabled = true
            } else {
                manager = managers[0]
            }

            manager.saveToPreferences { (error) in
                if let error = error {
                    print("Error saving VPN configuration: \(error.localizedDescription)")
                    return
                }

                do {
                    try manager.connection.startVPNTunnel()
                } catch {
                    print("Error starting VPN tunnel: \(error.localizedDescription)")
                }
            }
        }
    }

    func stopVPN() {
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
            guard let managers = managers, let manager = managers.first, error == nil else {
                return
            }
            manager.connection.stopVPNTunnel()
        }
    }

    func handleDNSRequest(request: Data) -> Data {
        // Handle the DNS request and return a response
        return Data()
    }

    func handle(intent: ToggleVPNIntent, completion: @escaping (ToggleVPNIntentResponse) -> Void) {
        if vpnStatus == .connected {
            stopVPN()
        } else {
            startVPN()
        }
        let response = ToggleVPNIntentResponse(code: .success, userActivity: nil)
        completion(response)
    }
}
