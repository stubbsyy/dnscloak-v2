import SwiftUI

struct TutorialView: View {
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Text(NSLocalizedString("Welcome to DNSCloak", comment: ""))
                .font(.largeTitle)
                .padding()

            Text(NSLocalizedString("This tutorial will guide you through the main features of the app.", comment: ""))
                .font(.headline)
                .padding()

            Button(NSLocalizedString("Get Started", comment: "")) {
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
