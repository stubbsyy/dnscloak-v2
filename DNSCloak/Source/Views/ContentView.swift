import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenTutorial") private var hasSeenTutorial = false
    @StateObject private var settings = Settings()
    @State private var showingMenu = false

    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showingMenu = false
                    }
                }
            }

        return NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    MainView(showingMenu: self.$showingMenu)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(x: self.showingMenu ? geometry.size.width/2 : 0)
                        .disabled(self.showingMenu ? true : false)
                    if self.showingMenu {
                        SideMenuView()
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .leading))
                    }
                }
                .gesture(drag)
            }
            .navigationBarTitle(NSLocalizedString("DNSCloak", comment: ""), displayMode: .inline)
            .navigationBarItems(leading: (
                Button(action: {
                    withAnimation {
                        self.showingMenu.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                }
            ))
        }
        .environmentObject(settings)
        .sheet(isPresented: .constant(!hasSeenTutorial)) {
            TutorialView(isPresented: $hasSeenTutorial)
        }
    }
}

struct MainView: View {
    @Binding var showingMenu: Bool

    var body: some View {
        Button(action: {
            withAnimation {
               self.showingMenu = true
            }
        }) {
            Text(NSLocalizedString("Show Menu", comment: ""))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
