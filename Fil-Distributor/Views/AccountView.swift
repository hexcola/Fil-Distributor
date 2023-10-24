//
//  AccountView.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/22.
//

import SwiftUI

struct AccountView: View {
    @Binding var key:Key?
    @State private var isPresented = false
    @State private var isAlert = false
    @State private var alertMessage = ""
    @State private var receiverFilename = ""
    @State private var receivers:[Receiver] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                // background
                Color.clear
                    .ignoresSafeArea()
                
                // foreground
                VStack {
                    
                    BalanceView(accountAddress: key!.address)
//                        .padding(.top, 30)
                    //                Spacer()
                    HistoryView()
                        .frame(height: 450)
                    
                    ExcelHandlerView(callback: { receivers, receiverFilename, error in
                        // Navigate to DispatchView if `receivers` data is good
                        if error != nil {
                            self.isAlert = true
                            self.alertMessage = error!.localizedDescription
                        } else {
                            self.receiverFilename = receiverFilename
                            self.receivers = receivers!
                            self.isPresented = true
                        }
                    })
                }
            }.navigationDestination(isPresented: self.$isPresented ) {
                DispatchView(receiverFilename: receiverFilename,  sender: key!, receivers: receivers)
            }.alert(self.alertMessage, isPresented: self.$isAlert) {
                Button("OK", role: .cancel){}
            }
        }
    }
}

#Preview {
    AccountView(key: .constant(Key(from: ProcessInfo.processInfo.environment["DEV_SENDER_PRIVATE_KEY"]!,
                         address: ProcessInfo.processInfo.environment["DEV_SENDER_ADDRESS"]!)!))
    
}
