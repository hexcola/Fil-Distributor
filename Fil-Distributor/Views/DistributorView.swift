//
//  DistributorView.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/20.
//

import SwiftUI

struct DistributorView: View {
    @Binding var fromAccount: Account
    @Binding var receivers: [Receiver]?
    
    var body: some View {
        
        Button(action: {
            print("Sign message for")
            if (receivers != nil) {
                let distributor = Distributor(fromAccount: fromAccount, receivers: receivers!)
                distributor.send()
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
    DistributorView(fromAccount: .constant(Account(address: "x")), receivers: .constant([
        Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 1),
        Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 2),
        Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 3),
        Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 4),
    ]))
}
