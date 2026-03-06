import SwiftUI

struct ContentView: View {
    @StateObject var account = AccountModel()
    @State private var selectedTab: Int = 0
    @State private var showEdit = false
    @State private var showCard = false

    var body: some View {
        ZStack(alignment: .bottom) {
            if showCard {
                CardView(account: account, isPresented: $showCard)
                    .transition(.move(edge: .bottom))
            } else {
                MoneyView(account: account,
                          showEdit: $showEdit,
                          showCard: $showCard)
                    .ignoresSafeArea()
            }

            if !showCard {
                BottomTabBar(account: account, selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showEdit) {
            EditAccountSheet(account: account)
        }
        .preferredColorScheme(account.isDarkMode ? .dark : .light)
        .animation(.easeInOut(duration: 0.3), value: showCard)
    }
}
