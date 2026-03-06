import SwiftUI

struct EditAccountSheet: View {
    @ObservedObject var account: AccountModel
    @Environment(\.dismiss) var dismiss

    @State private var balanceText = ""
    @State private var savingsText = ""
    @State private var bitcoinText = ""
    @State private var bitcoinChange = ""
    @State private var cashtag = ""
    @State private var cardLast4 = ""
    @State private var accountLast4 = ""
    @State private var cardholderName = ""
    @State private var profileLetter = ""
    @State private var profileColor = ""
    @State private var greenRenews = ""
    @State private var notifCount = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("💰 Cash Balance")) {
                    HStack { Text("$"); TextField("e.g. 58078.00", text: $balanceText).keyboardType(.decimalPad) }
                }
                Section(header: Text("🌹 Savings")) {
                    HStack { Text("$"); TextField("e.g. 14500.00", text: $savingsText).keyboardType(.decimalPad) }
                }
                Section(header: Text("₿ Bitcoin")) {
                    HStack { Text("Value $"); TextField("e.g. 12552.47", text: $bitcoinText).keyboardType(.decimalPad) }
                    HStack { Text("Change %"); TextField("e.g. -0.24", text: $bitcoinChange).keyboardType(.decimalPad) }
                }
                Section(header: Text("💳 Card")) {
                    HStack { Text("Cashtag"); Spacer(); TextField("e.g. $ifstanwasrich", text: $cashtag).multilineTextAlignment(.trailing) }
                    HStack { Text("Card last 4"); Spacer(); TextField("e.g. 5109", text: $cardLast4).keyboardType(.numberPad).multilineTextAlignment(.trailing) }
                    HStack { Text("Account last 4"); Spacer(); TextField("e.g. 2841", text: $accountLast4).keyboardType(.numberPad).multilineTextAlignment(.trailing) }
                    HStack { Text("Cardholder name"); Spacer(); TextField("e.g. Elliot Payne", text: $cardholderName).multilineTextAlignment(.trailing) }
                }
                Section(header: Text("🎨 Profile")) {
                    HStack { Text("Letter"); Spacer(); TextField("e.g. B", text: $profileLetter).multilineTextAlignment(.trailing) }
                    HStack { Text("Color (hex)"); Spacer(); TextField("e.g. 8B5CF6", text: $profileColor).multilineTextAlignment(.trailing) }
                    HStack { Text("Green renews"); Spacer(); TextField("e.g. Renews Mar 1", text: $greenRenews).multilineTextAlignment(.trailing) }
                    HStack { Text("Badge count"); Spacer(); TextField("e.g. 1", text: $notifCount).keyboardType(.numberPad).multilineTextAlignment(.trailing) }
                }
                Section {
                    Button(action: saveAndDismiss) {
                        HStack {
                            Spacer()
                            Text("Save Changes").font(.system(size: 17, weight: .bold)).foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowBackground(Color(hex: "00D632"))
                }
            }
            .navigationTitle("Edit Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
            }
        }
        .onAppear(perform: loadValues)
    }

    func loadValues() {
        balanceText   = String(format: "%.2f", account.balance)
        savingsText   = String(format: "%.2f", account.savingsBalance)
        bitcoinText   = String(format: "%.2f", account.bitcoinBalance)
        bitcoinChange = String(format: "%.2f", account.bitcoinChange)
        cashtag       = account.cashtag
        cardLast4     = account.cardLastFour
        accountLast4  = account.accountLastFour
        cardholderName = account.cardholderName
        profileLetter = account.profileLetter
        profileColor  = account.profileColor
        greenRenews   = account.greenStatusRenews
        notifCount    = "\(account.notificationCount)"
    }

    func saveAndDismiss() {
        if let v = Double(balanceText)   { account.balance = v }
        if let v = Double(savingsText)   { account.savingsBalance = v }
        if let v = Double(bitcoinText)   { account.bitcoinBalance = v }
        if let v = Double(bitcoinChange) { account.bitcoinChange = v }
        if !cashtag.isEmpty              { account.cashtag = cashtag }
        if cardLast4.count == 4          { account.cardLastFour = cardLast4 }
        if accountLast4.count == 4       { account.accountLastFour = accountLast4 }
        if !cardholderName.isEmpty       { account.cardholderName = cardholderName }
        if !profileLetter.isEmpty        { account.profileLetter = String(profileLetter.prefix(1)) }
        if !profileColor.isEmpty         { account.profileColor = profileColor }
        if !greenRenews.isEmpty          { account.greenStatusRenews = greenRenews }
        if let n = Int(notifCount)       { account.notificationCount = n }
        dismiss()
    }
}
