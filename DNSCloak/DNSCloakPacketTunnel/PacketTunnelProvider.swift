import NetworkExtension
import os.log

class PacketTunnelProvider: NEPacketTunnelProvider {
    let logger = OSLog(subsystem: "com.example.DNSCloak.PacketTunnel", category: "PacketTunnel")
    var dnsProxy: DNSProxy?

    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        let tunnelNetworkSettings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "8.8.8.8")
        tunnelNetworkSettings.ipv4Settings = NEIPv4Settings(addresses: ["192.168.1.1"], subnetMasks: ["255.255.255.0"])
        tunnelNetworkSettings.dnsSettings = NEDNSSettings(servers: ["8.8.8.8"])

        setTunnelNetworkSettings(tunnelNetworkSettings) { [weak self] error in
            if let error = error {
                self?.logger.error("Failed to set tunnel network settings: \(error.localizedDescription)")
                completionHandler(error)
                return
            }
            let settings = Settings(appGroup: "group.com.example.DNSCloak")
            self?.dnsProxy = DNSProxy(settings: settings)
            completionHandler(nil)
            self?.readPackets()
        }
    }

    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func readPackets() {
        packetFlow.readPackets { [weak self] packets, protocols in
            guard let self = self else { return }
            for packet in packets {
                if let response = self.dnsProxy?.handlePacket(packet) {
                    self.packetFlow.writePackets([response], withProtocols: protocols)
                }
            }
            self.readPackets()
        }
    }

    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        // Add code here to handle messages from the app
        if let handler = completionHandler {
            handler(nil)
        }
    }
}
