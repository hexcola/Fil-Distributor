//
//  Key.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/21.
//

import Foundation

enum KeyType: String, Codable {
    case secp2561k = "secp256k1"
    case bls = "bls"
}

struct PrivateKey: Codable {
    private var value: String
    
    init(_ value: String) {
        self.value = value
    }
    
    func string() -> String {
        return value
    }
    
    func bytes() -> [UInt8]? {
        if let data = value.data(using: .utf8) {
            if let byteArray = Data(base64Encoded: data) {
                return [UInt8](byteArray)
            } else {
                return nil
            }
        }
        return nil
    }
}

struct KeyInfo:Codable {
    var type: KeyType
    var privateKey: PrivateKey
    
    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case privateKey = "PrivateKey"
    }
}

struct Address:Codable {
    private var value: String
    
    init(_ value: String) {
        self.value = value
    }
    
    func string() -> String {
        return value
    }
}

struct Key:Codable {
    var keyInfo: KeyInfo
    var address: Address
}
