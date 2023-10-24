//
//  AccountView.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/22.
//

import SwiftUI

struct AccountView: View {
    @State var key:Key
    
    var body: some View {
        ZStack {
            // background
            Color.clear
                .ignoresSafeArea()
            
            // foreground
            VStack {
                BalanceView(accountAddress: $key.address)
                //                Spacer()
                HistoryView()
                    .frame(height: 500)
                
                ExcelHandlerView(callback: { receivers in
                    print(receivers)
                    
                })
            }
        }
    }
}

#Preview {
    AccountView(key: Key(from: ProcessInfo.processInfo.environment["DEV_SENDER_PRIVATE_KEY"]!,
                                  address: ProcessInfo.processInfo.environment["DEV_SENDER_ADDRESS"]!)!)
    
}
