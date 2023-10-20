//
//  ContentView.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/20.
//

import SwiftUI

struct ContentView: View {
    @State private var account = Account(address: "f1abcdef12345678901234567890abcdef1234567")
    @State private var showingAlert = false
    @State private var receivers: [Receiver]?
    
    @State var filename = "Filename"
    @State var showFileChooser = false
    
    var body: some View {
        VStack {
            BalanceView(accountAddress: $account.address)
            
            // Read Excel and return data.
            ExcelHandlerView(callback: { data in
                receivers = data
            })
            
            // Send Fils to all receivers.
            DistributorView(fromAccount: $account, receivers: $receivers)
            
            // List all receivers and total Fils to confirm
            ReceiverListView(receivers: $receivers)
                .padding()
         
            
            // add a button to transfer
//            if !receivers.isEmpty {
//                Button(action: {
//                    let dist = Distributor(fromAccount: account, receivers: receivers)
//                    dist.send()
//                }, label: {
//                    Label("Send", systemImage: "paperplane")
//                })
//                .padding()
//            }

        }
        
    }
}

#Preview {
    ContentView()
}
