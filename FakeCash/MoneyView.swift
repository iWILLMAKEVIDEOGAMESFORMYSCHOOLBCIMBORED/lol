import SwiftUI

struct MoneyView: View {
    @ObservedObject var account: AccountModel
    @Binding var showEdit: Bool
    @Binding var showCard: Bool
    @State private var balanceHidden = false
    @State private var toastMessage: String? = nil
    @State private var cardRotation: Double = 0
    @State private var cardFlipped = false

    var isDark: Bool { account.isDarkMode }

    var bgColor: Color { isDark ? Color(hex: "000000") : Color(hex: "f2f2f7") }
    var cardBg: Color { isDark ? Color(hex: "1c1c1e") : Color(hex: "ffffff") }
    var textPrimary: Color { isDark ? .white : .black }
    var textSecondary: Color { isDark ? Color(hex: "8e8e93") : Color(hex: "6c6c70") }

    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header
                    headerSection

                    // Card chip strip
                    cardChipStrip
                        .onTapGesture { flipCard() }

                    // Balance white/dark card
                    balanceCard

                    // Savings tile
                    savingsTile
                        .padding(.horizontal, 16)
                        .padding(.top, 12)

                    // Bitcoin tile
                    bitcoinTile
                        .padding(.horizontal, 16)
                        .padding(.top, 12)

                    // More for you
                    moreForYouSection

                    // Add money
                    addMoneySection

                    // FDIC
                    disclosureSection

                    Color.clear.frame(height: 90)
                }
            }

            // Toast
            if let msg = toastMessage {
                VStack {
                    Spacer().frame(height: 70)
                    Text(msg)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20).padding(.vertical, 12)
                        .background(Color(hex: "1c1c1e"))
                        .cornerRadius(14)
                        .shadow(color: .black.opacity(0.4), radius: 10)
                    Spacer()
                }
                .zIndex(10)
            }
        }
    }

    // MARK: - Header
    var headerSection: some View {
        HStack(alignment: .center) {
            Text("Money")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(textPrimary)
            Spacer()

            // Dark/Light toggle
            Button(action: { account.isDarkMode.toggle() }) {
                Image(systemName: account.isDarkMode ? "sun.max.fill" : "moon.fill")
                    .font(.system(size: 18))
                    .foregroundColor(textPrimary)
            }
            .padding(.trailing, 12)

            Button(action: {}) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(textPrimary)
            }
            .padding(.trailing, 14)

            Button(action: { showEdit = true }) {
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .fill(Color(hex: account.profileColor))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Text(account.profileLetter)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        )
                    if account.notificationCount > 0 {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 16, height: 16)
                            .overlay(
                                Text("\(account.notificationCount)")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .offset(x: 4, y: -4)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 56)
        .padding(.bottom, 16)
    }

    // MARK: - Card chip strip (tappable, flips to CardView)
    var cardChipStrip: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: isDark
                            ? [Color(hex: "c8a96e"), Color(hex: "f5e6c8"), Color(hex: "e8c97a")]
                            : [Color(hex: "d4d4d4"), Color(hex: "f5f5f5"), Color(hex: "e0e0e0")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 70)

            HStack {
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.black.opacity(0.4))
                        .frame(width: 24, height: 17)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.black.opacity(0.6))
                                .frame(width: 9, height: 7)
                        )
                    Text("•• \(account.cardLastFour)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black.opacity(0.8))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(Color.black.opacity(0.1))
                .cornerRadius(20)

                Spacer()
                Text(account.cashtag)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.black.opacity(0.7))
            }
            .padding(.horizontal, 18)
        }
        .padding(.horizontal, 16)
        .rotation3DEffect(.degrees(cardRotation), axis: (x: 0, y: 1, z: 0))
        .onTapGesture { flipCard() }
    }

    func flipCard() {
        withAnimation(.easeInOut(duration: 0.4)) {
            cardRotation = 180
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            showCard = true
            cardRotation = 0
        }
    }

    // MARK: - Balance Card
    var balanceCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Balance header row
            HStack {
                HStack(spacing: 6) {
                    Text("Cash balance •• \(account.accountLastFour)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(textPrimary)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(textPrimary)
                }
                Spacer()
                Button(action: { balanceHidden.toggle() }) {
                    Image(systemName: "eye.slash")
                        .font(.system(size: 20))
                        .foregroundColor(textSecondary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 22)
            .padding(.bottom, 4)

            // Balance
            Text(balanceHidden ? "••••••" : account.balanceDisplay)
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(textPrimary)
                .tracking(-1.5)
                .padding(.horizontal, 20)
                .padding(.bottom, 24)

            // Add/Withdraw buttons
            HStack(spacing: 12) {
                darkActionButton(title: "Add money")
                darkActionButton(title: "Withdraw")
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)

            // Green status
            HStack(spacing: 10) {
                Circle()
                    .fill(Color(hex: "00D632"))
                    .frame(width: 14, height: 14)
                Text("Green status")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(textPrimary)
                Spacer()
                Text(account.greenStatusRenews)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(isDark ? Color(hex: "1c1c1e") : Color(hex: "f0f0f0"))
            .cornerRadius(16)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(isDark ? Color(hex: "000000") : Color(hex: "ffffff"))
    }

    func darkActionButton(title: String) -> some View {
        Button(action: { showToast("\(title) tapped") }) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(isDark ? Color(hex: "1c1c1e") : Color(hex: "eeeeee"))
                .cornerRadius(50)
        }
    }

    // MARK: - Savings Tile
    var savingsTile: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(isDark ? Color(hex: "1c1c1e") : Color(hex: "ffffff"))

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Savings")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(textPrimary)
                    Text(account.savingsDisplay)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(textPrimary)
                    Text("Up to 3.25% interest")
                        .font(.system(size: 13))
                        .foregroundColor(textSecondary)
                }
                Spacer()
                Circle()
                    .stroke(Color(hex: "00D632"), lineWidth: 2)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Text("$")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "00D632"))
                    )
            }
            .padding(20)
        }
        .onTapGesture { showToast("Savings tapped") }
    }

    // MARK: - Bitcoin Tile
    var bitcoinTile: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(isDark ? Color(hex: "1c1c1e") : Color(hex: "ffffff"))

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Bitcoin")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(textPrimary)
                    Text(account.bitcoinDisplay)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(textPrimary)
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.red)
                        Text(String(format: "%.2f%%", abs(account.bitcoinChange)))
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.red)
                        Text("today")
                            .font(.system(size: 13))
                            .foregroundColor(textSecondary)
                    }
                }
                Spacer()
                // Mini chart
                BitcoinChartView()
                    .frame(width: 100, height: 50)
            }
            .padding(20)
        }
        .onTapGesture { showToast("Bitcoin tapped") }
    }

    // MARK: - More For You
    var moreForYouSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("More for you")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(textPrimary)
                .padding(.horizontal, 20)
                .padding(.top, 28)
                .padding(.bottom, 18)

            let items: [(String, String, String)] = [
                ("💵", "Paychecks", "Get paid faster"),
                ("🪙", "Bitcoin",   "Learn and invest"),
                ("🌹", "Savings",   "Up to 3.25% interest"),
                ("📈", "Stocks",    "Invest with $1"),
                ("💎", "Pools",     "Collect money with anyone"),
            ]
            ForEach(items, id: \.1) { icon, label, sub in
                HStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(isDark ? Color(hex: "2c2c2e") : Color(hex: "f0f0f0"))
                        .frame(width: 52, height: 52)
                        .overlay(Text(icon).font(.system(size: 26)))
                    VStack(alignment: .leading, spacing: 3) {
                        Text(label).font(.system(size: 17, weight: .semibold)).foregroundColor(textPrimary)
                        Text(sub).font(.system(size: 14)).foregroundColor(textSecondary)
                    }
                    Spacer()
                    Button(action: { showToast("Starting \(label)") }) {
                        Text("Start")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(textPrimary)
                            .padding(.horizontal, 18).padding(.vertical, 9)
                            .background(isDark ? Color(hex: "2c2c2e") : Color(hex: "f0f0f0"))
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
    }

    // MARK: - Add Money
    var addMoneySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Add money")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(textPrimary)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 6)

            let items: [(String, String)] = [
                ("arrow.down.to.line", "Direct deposit"),
                ("arrow.2.circlepath", "Get bank or wire transfer"),
                ("banknote",           "Deposit paper money"),
                ("doc.viewfinder",     "Deposit check"),
                ("repeat",             "Auto reload"),
            ]
            ForEach(Array(items.enumerated()), id: \.1.1) { idx, item in
                let (icon, label) = item
                VStack(spacing: 0) {
                    HStack(spacing: 16) {
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .foregroundColor(textPrimary)
                            .frame(width: 28)
                        Text(label)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(textPrimary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(textSecondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .contentShape(Rectangle())
                    .onTapGesture { showToast("\(label) tapped") }

                    if idx < items.count - 1 {
                        Divider()
                            .background(isDark ? Color(hex: "2c2c2e") : Color(hex: "e0e0e0"))
                            .padding(.leading, 64)
                    }
                }
            }
        }
    }

    // MARK: - Disclosure
    var disclosureSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            (Text("Your balance is eligible for FDIC pass-through insurance through Wells Fargo Bank, N.A., Sutton Bank, and/or The Bancorp Bank, N.A., Members FDIC for up to $250,000 per customer when aggregated with all other deposits held in the same legal capacity at each bank, if certain conditions are met. See the ")
             + Text("Cash App Terms of Service.").underline())
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(textSecondary)

            (Text("Banking services provided by Cash App's bank partner(s). Brokerage services by Cash App Investing LLC. ")
             + Text("Disclosures").underline())
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(textSecondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }

    func showToast(_ message: String) {
        withAnimation { toastMessage = message }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { toastMessage = nil }
        }
    }
}

// MARK: - Bitcoin Chart Shape
struct BitcoinChartView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let points: [CGFloat] = [0.6, 0.8, 0.4, 0.7, 0.5, 0.3, 0.55, 0.4, 0.6, 0.35, 0.5, 0.2, 0.4, 0.15, 0.3]
            let step = w / CGFloat(points.count - 1)

            Path { path in
                path.move(to: CGPoint(x: 0, y: h * points[0]))
                for (i, p) in points.enumerated() {
                    path.addLine(to: CGPoint(x: CGFloat(i) * step, y: h * p))
                }
            }
            .stroke(Color(hex: "00D632"), style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
        }
    }
}

// MARK: - Bottom Tab Bar
struct BottomTabBar: View {
    @ObservedObject var account: AccountModel
    @Binding var selectedTab: Int

    var isDark: Bool { account.isDarkMode }
    var bg: Color { isDark ? Color(hex: "000000") : Color(hex: "ffffff") }
    var fg: Color { isDark ? .white : .black }
    var inactive: Color { isDark ? Color(hex: "636366") : Color(hex: "aaaaaa") }

    var body: some View {
        HStack {
            Spacer()
            Button(action: { selectedTab = 0 }) {
                Text(account.balanceRounded)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(selectedTab == 0 ? fg : inactive)
            }
            Spacer()
            Button(action: { selectedTab = 1 }) {
                Text("$")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(selectedTab == 1 ? fg : inactive)
            }
            Spacer()
            ZStack(alignment: .topTrailing) {
                Button(action: { selectedTab = 2 }) {
                    Image(systemName: "clock")
                        .font(.system(size: 22))
                        .foregroundColor(selectedTab == 2 ? fg : inactive)
                }
                if account.notificationCount > 0 {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Text("\(account.notificationCount)")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .offset(x: 9, y: -9)
                }
            }
            Spacer()
        }
        .padding(.top, 12)
        .padding(.bottom, 34)
        .background(bg.ignoresSafeArea(edges: .bottom))
        .overlay(
            Divider()
                .background(isDark ? Color(hex: "2c2c2e") : Color(hex: "e0e0e0")),
            alignment: .top
        )
    }
}
