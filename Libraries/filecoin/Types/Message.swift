//
//  Message.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/21.
//

import Foundation

enum FilecoinMethod:Int,Codable {
    case send = 0
}

struct Message: Codable {
    var version: Int
    var to: String
    var from: String
    var nonce: Int
    var value: String
    var gasLimit: Int
    var gasFeeCap: String
    var gasPremium: String
    var method: FilecoinMethod
    var params: String?
    var cid: CID?
    
    init(from: String, to: String, value: String, params:String?, method: FilecoinMethod = FilecoinMethod.send) {
        self.version = 0
        self.from = from
        self.to = to
        self.nonce = 0
        self.value = value
        self.gasLimit = 0
        self.gasFeeCap = "0"
        self.gasPremium = "0"
        self.method = method
        self.params = params
    }
    
    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case to = "To"
        case from = "From"
        case nonce = "Nonce"
        case value = "Value"
        case gasLimit = "GasLimit"
        case gasFeeCap = "GasFeeCap"
        case gasPremium = "GasPremium"
        case method = "Method"
        case params = "Params"
        case cid = "CID"
    }
    
    mutating func setNonce(_ nonce: Int) {
        self.nonce = nonce
    }
}

struct SignedMessage: Codable {
    var message: Message
    var signature: Signature
    
    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case signature = "Signature"
    }
}

struct Receipt: Codable {
    var from: String
    var to: String
    var nonce: Int
    var value: String
    var cid: CID?
    
    enum CodingKeys: String, CodingKey {
        case to = "To"
        case from = "From"
        case nonce = "Nonce"
        case value = "Value"
        case cid = "CID"
    }
}
