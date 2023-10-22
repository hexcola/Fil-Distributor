//
//  BalanceView.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/20.
//

import SwiftUI


struct BalanceView: View {
    
    @Binding var accountAddress: String
    @State var accountBalance: Double = 0
    private let filecoin = Filecoin()
    
    var body: some View {
        Text("Account: \(accountAddress)")
        
        // Display
        Text("Balance: \(accountBalance)").onAppear {
            filecoin.wallet.balance(sender: accountAddress, completion: { result in
                do {
                    accountBalance = try result.get()
                } catch {
                    print(error)
                }
            })
        }
    }
}

#Preview {
    // NOTE:
    // If you encounter an error here, add a `DEV_SENDER_ADDRESS`
    // environment variable to Xcode project schema
    // REF: https://m25lazi.medium.com/environment-variables-in-xcode-a78e07d223ed
    BalanceView(accountAddress: .constant(ProcessInfo.processInfo.environment["DEV_SENDER_ADDRESS"]!))
}
