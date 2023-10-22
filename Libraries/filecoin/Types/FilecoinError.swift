//
//  FilecoinError.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/21.
//

import Foundation

enum FilecoinError: Error {
    case wrongMessageSize
    
    case wrongPrivateKeySize
    
    case invalidPrivateKey
    
    case signatureFailed
}

extension FilecoinError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .wrongMessageSize:
            return "Message size must be 32"
        case .wrongPrivateKeySize:
            return "Private key size must be 32"
        case .invalidPrivateKey:
            return "Private key invalid"
        case .signatureFailed:
            return "Signature failed"
        }
    }
}
