//
//  Key.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/21.
//

import Foundation
import secp256k1
import CryptoKit

enum KeyType: String, Codable {
    case secp2561k = "secp256k1"
    case bls = "bls"
}

struct KeyInfo:Codable {
    var type: KeyType
    var privateKey: String
    
    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case privateKey = "PrivateKey"
    }
}

extension String {
    func bytes() -> [UInt8]? {
        if let data = self.data(using: .utf8) {
            if let byteArray = Data(base64Encoded: data) {
                return [UInt8](byteArray)
            } else {
                return nil
            }
        }
        return nil
    }
    
    func hexToString() -> String? {
        var hex = self
        var str = ""
        
        if hex.count % 2 != 0 {
            print("hex string count should be a even number")
            return nil
        }
        
        while hex.count > 0 {
            let index = hex.index(hex.startIndex, offsetBy: 2)
            let hexByte = String(hex[..<index])
            
            if let char = UInt8(hexByte, radix: 16) {
                str.append(Character(UnicodeScalar(char)))
                hex = String(hex[index...])
            } else {
                // Invalid hex byte
                return nil
            }
        }
        
        return str
    }
}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

struct Key {
    var keyInfo: KeyInfo
    var address: String
    
    init?(from:String, address:String) {
        if let normalString = from.hexToString() {
            do {
                guard let data = normalString.data(using: .utf8) else {
                    return nil
                }
                
                let decoder = JSONDecoder()
                self.keyInfo = try decoder.decode(KeyInfo.self, from: data)
                self.address = address
                return
            } catch {
                print(error)
                return nil
            }
        } else {
            print("Invalid hex string")
        }
        return nil
    }
    
    // TODO: generate publicKey address from privateKey
    init?(from: String) {
        if let normalString = from.hexToString() {
            do {
                let data = normalString.data(using: .utf8)!
                let decoder = JSONDecoder()
                self.keyInfo = try decoder.decode(KeyInfo.self, from: data)
                self.address = "what ever"
                
                //                let priData = Data(bytes: self.keyInfo.privateKey.bytes()!, count: 32)
                let priData = Data(base64Encoded: self.keyInfo.privateKey.data(using: .utf8)!)
                let address = self.genAddress(privateKey: priData!)
                
            } catch {
                print(error)
                return nil
            }
        } else {
            print("Invalid hex string")
            return nil
        }
        return nil
    }
    
    // WARN: this function is not working
    func genAddress(privateKey: Data) -> String {
        guard let publicKey = try? P256.Signing.PrivateKey(rawRepresentation: privateKey).publicKey.rawRepresentation else {
            fatalError("Failed to generate public key")
        }
        
        // Step 2: Apply multihash function (SHA2-256)
        let hash = SHA256.hash(data: publicKey)
        
        // Step 3: Append multihash function code
        var multihash = Data([0x12, 0x20]) // Code for SHA2-256 followed by the length of the hash
        multihash += hash
        
        // Step 4: Encode with Base32
        //         let base32Encoded = multihash.base32EncodedString()
        let base32Encoded = multihash.base32String().lowercased()
        print(base32Encoded)
        
        // Step 5: Add the Filecoin address prefix "f1"
        let filecoinAddress = "f1" + base32Encoded.dropFirst(2) // Drop the first two characters "b0"
        
        return filecoinAddress
    }
}
