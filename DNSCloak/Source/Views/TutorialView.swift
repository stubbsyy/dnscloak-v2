import SwiftUI

struct TutorialView: View {
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Text("Welcome to DNSCloak")
                .font(.largeTitle)
                .padding()

            Text("This tutorial will guide you through the main features of the app.")
                .font(.headline)
                .padding()

            Button("Get Started") {
                isPresented = false
            }
            .padding()
        }
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView(isPresented: .constant(true))
    }
}
