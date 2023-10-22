//
//  ContentView.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/20.
//

import SwiftUI

struct ContentView: View {
    // NOTE:
    // If you encounter an error here, add a `DEV_SENDER_ADDRESS`
    // environment variable to Xcode project schema
    // REF: https://m25lazi.medium.com/environment-variables-in-xcode-a78e07d223ed
    
    // TODO: This is just for dev, need to add wallet management feature
    @State private var account = Account(address: ProcessInfo.processInfo.environment["DEV_SENDER_ADDRESS"]!)
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
            DistributorView(sender: $account, receivers: $receivers)
            
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
