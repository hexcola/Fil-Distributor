//
//  BalanceView.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/20.
//

import SwiftUI


struct BalanceView: View {
    var accountAddress: String
    @State var accountBalance: Double = 0
    private let filecoin = Filecoin()
    
    var body: some View {
        VStack {
            Image("filecoin")
                .resizable()
                .frame(width: 100, height: 88)
            
            // Address & Copy
            HStack {
                Text("\(accountAddress)")
                    .font(.caption)
                    .foregroundStyle(Color.white)
                
                Button(action: {
                    // TODO: copy
                    print("Copy it, WIP")
                }, label: {
                    Label("", systemImage: "doc.on.doc")
                        .foregroundColor(.white)
                })
            }
            
            // Display
            Text("\(accountBalance) FIL")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundStyle(Color.white)
                .onAppear {                
                    filecoin.wallet.balance(sender: accountAddress, completion: { result in
                        do {
                            accountBalance = try result.get()
                        } catch {
                            print(error)
                        }
                    })
                }
        }
        .frame(width: 360, height: 200)
        .background(
            //            LinearGradient(gradient: Gradient(colors: [.yellow,.purple, .pink, .purple, .yellow]), startPoint: .bottomLeading, endPoint: .topTrailing)
            //            
            RadialGradient(gradient: Gradient(colors: [.yellow,.purple, .pink, .purple, .yellow]), center: .center, startRadius: 2, endRadius: 650)
        )
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 5)
    }
}

#Preview {
    // NOTE:
    // If you encounter an error here, add a `DEV_SENDER_ADDRESS`
    // environment variable to Xcode project schema
    // REF: https://m25lazi.medium.com/environment-variables-in-xcode-a78e07d223ed
    BalanceView(accountAddress: ProcessInfo.processInfo.environment["DEV_SENDER_ADDRESS"]!)
}
