import SwiftUI

struct CardView: View {
    @ObservedObject var account: AccountModel
    @Binding var isPresented: Bool

    @State private var cardRotation: Double = 0
    @State private var showCardDetails = false
    @State private var isFlipping = false
    @State private var cvvHidden = true
    @State private var expHidden = true

    var isDark: Bool { account.isDarkMode }
    var bg: Color { isDark ? .black : .white }
    var textPrimary: Color { isDark ? .white : .black }
    var textSecondary: Color { isDark ? Color(hex: "8e8e93") : Color(hex: "6c6c70") }
    var rowBg: Color { isDark ? Color(hex: "1c1c1e") : Color(hex: "f2f2f7") }

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Nav bar
                    HStack {
                        Button(action: { isPresented = false }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(textPrimary)
                        }
                        Spacer()
                        Text("Card")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(textPrimary)
                        Spacer()
                        Color.clear.frame(width: 24, height: 24)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 56)
                    .padding(.bottom, 20)

                    // Credit card visual - tappable for 360 spin
                    creditCardVisual
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                        .onTapGesture { spinCard() }

                    // Lock / Copy buttons
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            HStack(spacing: 8) {
                                Image(systemName: "lock")
                                    .font(.system(size: 16))
                                Text("Lock")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(rowBg)
                            .cornerRadius(50)
                        }

                        Button(action: {}) {
                            HStack(spacing: 8) {
                                Image(systemName: "doc.on.doc")
                                    .font(.system(size: 16))
                                Text("Copy •• \(account.cardLastFour)")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(rowBg)
                            .cornerRadius(50)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)

                    // Explore offers
                    HStack(spacing: 14) {
                        HStack(spacing: -10) {
                            Circle().fill(Color.yellow).frame(width: 42, height: 42)
                                .overlay(Text("DC").font(.system(size: 12, weight: .black)).foregroundColor(.black))
                            Circle().fill(Color(hex: "FF385C")).frame(width: 42, height: 42)
                                .overlay(Image(systemName: "a.circle.fill").font(.system(size: 20)).foregroundColor(.white))
                            Circle().fill(.black).frame(width: 42, height: 42)
                                .overlay(Image(systemName: "applelogo").font(.system(size: 18)).foregroundColor(.white))
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Explore offers")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(textPrimary)
                            Text("Instant discounts")
                                .font(.system(size: 13))
                                .foregroundColor(textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(textSecondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)

                    Divider()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)

                    // Spending section
                    sectionHeader("Spending")

                    menuRow(icon: "chart.bar.fill",    label: "Insights & activity", detail: "$3 in Mar")
                    menuRow(icon: "arrow.clockwise",   label: "Round Ups",           detail: "Off")
                    menuRow(icon: "link",              label: "Linked merchants",    detail: "")
                    menuRow(icon: "creditcard",        label: "Find an ATM",         detail: "")

                    Divider().padding(.horizontal, 20).padding(.vertical, 8)

                    // Manage card section
                    sectionHeader("Manage card")

                    menuRow(icon: "plus.rectangle.on.rectangle", label: "Add card to Apple Pay", detail: "")
                    menuRow(icon: "pencil.and.outline",           label: "Design a new card",    detail: "")
                    menuRow(icon: "nosign",                       label: "Blocked businesses",   detail: "")
                    menuRow(icon: "asterisk",                     label: "Change PIN",           detail: "")
                    menuRow(icon: "questionmark.circle",          label: "Get card support",     detail: "")

                    Color.clear.frame(height: 100)
                }
            }
        }
    }

    // MARK: - Credit Card Visual
    var creditCardVisual: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "2a2a2a"), Color(hex: "1a1a1a"), Color(hex: "0d0d0d")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 210)
                .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)

            // Eye icon top right
            VStack {
                HStack {
                    Spacer()
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "eye")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        )
                }
                Spacer()
            }
            .padding(16)

            VStack(alignment: .leading, spacing: 12) {
                Spacer()

                // Card number dots
                HStack(spacing: 20) {
                    dotGroup(4)
                    dotGroup(4)
                    dotGroup(4)
                    Text(account.cardLastFour)
                        .font(.system(size: 18, weight: .medium, design: .monospaced))
                        .foregroundColor(.white)
                }

                // Name + CVV + EXP + VISA
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(account.cardholderName)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                        HStack(spacing: 16) {
                            Text("CVV •••")
                                .font(.system(size: 13))
                                .foregroundColor(Color.white.opacity(0.7))
                            Text("EXP ••/••")
                                .font(.system(size: 13))
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                    }
                    Spacer()
                    Text("VISA")
                        .font(.system(size: 24, weight: .black, design: .serif))
                        .italic()
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 18)
        }
        .rotation3DEffect(.degrees(cardRotation), axis: (x: 0, y: 1, z: 0))
    }

    func dotGroup(_ count: Int) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<count, id: \.self) { _ in
                Circle()
                    .fill(Color.white)
                    .frame(width: 7, height: 7)
            }
        }
    }

    func spinCard() {
        guard !isFlipping else { return }
        isFlipping = true
        withAnimation(.easeInOut(duration: 0.8)) {
            cardRotation = 360
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
            cardRotation = 0
            isFlipping = false
        }
    }

    // MARK: - Section Header
    func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(textPrimary)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    // MARK: - Menu Row
    func menuRow(icon: String, label: String, detail: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(textPrimary)
                .frame(width: 28)
            Text(label)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(textPrimary)
            Spacer()
            if !detail.isEmpty {
                Text(detail)
                    .font(.system(size: 15))
                    .foregroundColor(textSecondary)
            }
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(textSecondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .contentShape(Rectangle())
    }
}
