import SwiftUI

struct AddBlocklistView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var url = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("URL", text: $url)
            }
            .navigationTitle("Add Blocklist")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
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
