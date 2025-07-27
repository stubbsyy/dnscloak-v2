import SwiftUI

struct AddBlocklistView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var url = ""

    var body: some View {
        NavigationView {
            Form {
                TextField(NSLocalizedString("Name", comment: ""), text: $name)
                TextField(NSLocalizedString("URL", comment: ""), text: $url)
            }
            .navigationTitle(NSLocalizedString("Add Blocklist", comment: ""))
            .navigationBarItems(leading: Button(NSLocalizedString("Cancel", comment: "")) {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button(NSLocalizedString("Save", comment: "")) {
                let newBlocklist = Blocklist(name: name, url: URL(string: url)!, isEnabled: true)
                settings.blocklists.append(newBlocklist)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct AddBlocklistView_Previews: PreviewProvider {
    static var previews: some View {
        AddBlocklistView()
    }
}
