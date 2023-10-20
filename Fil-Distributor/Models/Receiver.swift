//
//  Receiver.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/20.
//

import Foundation

struct Receiver: Codable, Identifiable {
    var id: UUID
    var address: String
    var amount: Double
    
    init(address: String, amount: Double) {
        self.id = UUID()
        self.address = address
        self.amount = amount
    }
}

