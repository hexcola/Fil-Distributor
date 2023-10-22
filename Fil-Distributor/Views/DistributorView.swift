//
//  DistributorView.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/20.
//

import SwiftUI

struct DistributorView: View {
    @Binding var sender: Account
    @Binding var receivers: [Receiver]?
    private let distributor = Distributor()
    
    var body: some View {
        
        Button(action: {
            // TODO: verify account
            
            // TODO: verify recivers
            if receivers != nil {
                // get nonce of sender
                distributor.dispatch(sender: sender, receivers: receivers!)
            }
        }, label: {
            Label("Send", systemImage: "paperplane")
        })
        .foregroundColor(.white)
        .padding()
        .background(receivers != nil ? Color.blue: Color.gray)
        .cornerRadius(10)
    }
}

#Preview {
    // NOTE:
    // If you encounter an error here, add a `DEV_SENDER_ADDRESS`
    // environment variable to Xcode project schema
    // REF: https://m25lazi.medium.com/environment-variables-in-xcode-a78e07d223ed
    DistributorView(sender: .constant(Account(address: ProcessInfo.processInfo.environment["DEV_SENDER_ADDRESS"]!)), receivers: .constant([
        Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 1),
        Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 2),
        Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 3),
        Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 4),
    ]))
}
