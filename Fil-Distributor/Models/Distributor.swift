//
//  Distributor.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/20.
//

import Foundation


struct Message:Codable {
    var Version: Int
    var To: String
    var From: String
    var Nonce: Int
    var Value: String
    var GasLimit: Int
    var GasFeeCap: String
    var GasPremium: String
    var Method: Int
    var Params: String
}

struct Distributor {
    var fromAccount: Account
    var receivers: [Receiver]
    
    func signMsg(){
        
    }
    
    func pushMsg(){
    }
    
    func send() {
        receivers.forEach { r in
            print("Send \(r.address): \(r.amount)")
        }
    }
}
