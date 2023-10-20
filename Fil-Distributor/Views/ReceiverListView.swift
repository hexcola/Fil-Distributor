//
//  ReceiverListView.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/20.
//

import SwiftUI


struct ReceiverListView: View {
    @Binding var receivers: [Receiver]?
    
    private var totalFils: Double {
        var t:Double = 0
        if receivers != nil {
            for receiver in receivers! {
                t += receiver.amount
            }
        }
        return t
    }
    
    var body: some View {
        if receivers != nil {
            VStack {
                Text("Total: \(totalFils)")
                List(receivers!) { receiver in
                    Text("\(receiver.address), \(receiver.amount)")
                }
            }
            
        } else {
            Text("No Data")
        }
    }
}

#Preview {
    ReceiverListView(receivers: .constant([
        Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 1),
        Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 2),
        Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 3),
        Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 4),
    ]))
}
