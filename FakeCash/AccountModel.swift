import Foundation
import SwiftUI

class AccountModel: ObservableObject {
    @Published var balance: Double = 58078.00
    @Published var savingsBalance: Double = 14500.00
    @Published var bitcoinBalance: Double = 12552.47
    @Published var bitcoinChange: Double = -0.24
    @Published var cardLastFour: String = "5109"
    @Published var accountLastFour: String = "2841"
    @Published var cashtag: String = "$ifstanwasrich"
    @Published var cardholderName: String = "Elliot Payne"
    @Published var profileEmoji: String = "🌍"
    @Published var profileColor: String = "8B5CF6"
    @Published var profileLetter: String = "B"
    @Published var greenStatusRenews: String = "Renews Mar 1"
    @Published var notificationCount: Int = 1
    @Published var isDarkMode: Bool = true

    var balanceDisplay: String { formatCurrency(balance) }
    var savingsDisplay: String { formatCurrency(savingsBalance) }
    var bitcoinDisplay: String { formatCurrency(bitcoinBalance) }
    var balanceRounded: String {
        if balance >= 1000 {
            return "$\(Int(balance / 1000))K"
        }
        return "$\(Int(balance))"
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}
