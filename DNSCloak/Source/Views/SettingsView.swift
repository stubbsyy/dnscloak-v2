import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        Form {
            Section(header: Text(NSLocalizedString("Blocklist", comment: ""))) {
                Stepper(String(format: NSLocalizedString("Limit: %d", comment: ""), settings.blocklistLimit), value: $settings.blocklistLimit, in: 1000...1000000, step: 1000)
            }
            Section(header: Text(NSLocalizedString("Updates", comment: ""))) {
                Picker(NSLocalizedString("Update Interval", comment: ""), selection: $settings.updateInterval) {
                    ForEach(UpdateInterval.allCases, id: \.self) { interval in
                        Text(interval.localizedDescription).tag(interval)
                    }
                }
            }
        }
        .navigationTitle(NSLocalizedString("Settings", comment: ""))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
