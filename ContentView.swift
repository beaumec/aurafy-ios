import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            AuraView()
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("My Aura")
                            .foregroundColor(.white)
                    }
                }
        }
        .background(Color.black)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
