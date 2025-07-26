import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        Form {
            Section(header: Text("Blocklist")) {
                Stepper("Limit: \(settings.blocklistLimit)", value: $settings.blocklistLimit, in: 1000...1000000, step: 1000)
            }
            Section(header: Text("Updates")) {
                Picker("Update Interval", selection: $settings.updateInterval) {
                    ForEach(UpdateInterval.allCases, id: \.self) { interval in
                        Text(interval.localizedDescription).tag(interval)
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
