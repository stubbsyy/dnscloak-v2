import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        Form {
            Picker("Update Interval", selection: $settings.updateInterval) {
                ForEach(UpdateInterval.allCases, id: \.self) { interval in
                    Text(interval.localizedDescription).tag(interval)
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
