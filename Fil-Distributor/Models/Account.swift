//
//  Account.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/20.
//

import Foundation

struct Account {
    var address: String
    var balance: Double {
        get {
            // TODO: reterive balance of this address
            return 0
        }
    }
    var privateKey: String {
        get {
            // TODO: add protect method
            return "unset"
        }
    }
    
    init(address: String) {
        self.address = address
    }
}
