# DNSCloak V2

DNSCloak V2 is a modern, open-source DNS-based ad blocker for iOS. It is a complete rewrite of the original DNSCloak app, with a focus on performance, stability, and user experience.

## Features

*   **Block Ads and Trackers:** Block ads and trackers on your iOS device.
*   **Multiple Blocklists:** Add multiple blocklists to the app.
*   **Combine and Deduplicate:** Combine all the fetched blocklists into a single master blocklist and remove any duplicate domains.
*   **Whitelist and Blacklist:** Whitelist or blacklist specific domains.
*   **DNS Query Log:** View all the DNS queries that have been made.
*   **Dual VPN Profile Support:** Run alongside other personal VPNs without any conflicts.
*   **Auto-Reconnect:** Automatically reconnect the VPN if the connection is dropped or interrupted.
*   **Support for More DNS Protocols:** The app now supports DNS-over-HTTPS, DNS-over-TLS, DNS-over-QUIC, and DNSCrypt.
*   **List of Privacy-Respecting Resolvers:** The app now includes a list of privacy-respecting DNS resolvers by default.
*   **Support for Custom Resolvers:** Users can now add their own custom resolvers.
*   **Blocklist Limit:** A configurable limit to the blocklist to improve the app's performance.
*   **UI Improvements:** The UI has been improved to be more user-friendly.
*   **Tutorial:** A tutorial has been added to guide new users through the app's features.

## License

This project is licensed under the Mozilla Public License 2.0. See the [LICENSE](LICENSE) file for details.

## Building and Running

To build and run the app locally, you will need to have Xcode installed.

1.  Clone the repository: `git clone https://github.com/s-s/dnscloak.git`
2.  Open the `DNSCloak.xcodeproj` file in Xcode.
3.  Select the `DNSCloak` scheme and a simulator or a physical device.
4.  Click the "Run" button.