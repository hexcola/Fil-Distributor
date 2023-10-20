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
//            if (receivers != nil) {
//                let distributor = Distributor(fromAccount: fromAccount, receivers: receivers!)
//                distributor.send()
//            }
            // TODO: remove the hardcode here.
            let cid = "<Your own message cid without first letter>"
            let pk = "<Your own secp256k1 private key>"
            let l = Lotus()
            if let msgData = l.cidToBytes(cid: cid.uppercased()) {
//                let y = [UInt8](msgData)
//                for byte in y {
//                    print(byte)
//                }
                let b2sum = l.blake2bSum256(msg: msgData)!
                if let pkData = l.pkToBytes(pk: pk) {
                    do {
                        let sig = try l.sign(msg: [UInt8](b2sum), seckey: [UInt8](pkData))
                        print(l.sigToString(sig: sig))
                    } catch {
                        print(error)
                        print("Can not get sig")
                    }
                } else {
                    print("Can not get pkData")
                }
            } else {
                print("something wrong")
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
