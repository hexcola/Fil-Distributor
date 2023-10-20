//
//  Distributor.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/20.
//

import Foundation
import Blake2
import secp256k1

enum LotusError: Error {
    case wrongMessageSize
    
    case wrongPrivateKeySize
    
    case invalidPrivateKey
    
    case signatureFailed
}

extension LotusError: CustomStringConvertible {
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

struct Lotus {
    func cidToBytes(cid: String) -> Data? {
        do {
            let data = try Base32.decode(string: cid)
            return data
        } catch {
            print("erro....")
            return nil
        }
    }
    
    func pkToBytes(pk: String) -> Data?{
        if let data = pk.data(using: .utf8) {
            let byteArray = Data(base64Encoded: data)
            return byteArray
        } else {
            print("faild to convert string to data")
            return nil
        }
    }
    
    func blake2bSum256(msg:Data) -> Data? {
        do {
            let hash = try! Blake2b.hash(size: 32, data: msg)
            return hash
        } catch {
            return nil
        }
    }
    
    func sigToString(sig:[UInt8]) -> String {
        return Data(sig).base64EncodedString()
    }
    
    func sign(msg:[UInt8], seckey:[UInt8]) throws -> [UInt8] {
//        let context = secp256k1_context_create(1)!
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))!
        
        if msg.count != 32 {
            throw LotusError.wrongMessageSize
        }
        
        if seckey.count != 32 {
            throw LotusError.wrongPrivateKeySize
        }
        
        let seckeydata = UnsafeMutablePointer(mutating: seckey)
        
        if secp256k1_ec_seckey_verify(context, seckeydata) != 1 {
            throw LotusError.invalidPrivateKey
        }
        
        let msgdata = UnsafeMutablePointer(mutating: msg)
        let noncefunc = secp256k1_nonce_function_rfc6979
        var sigstruct = secp256k1_ecdsa_recoverable_signature()
        
        if secp256k1_ecdsa_sign_recoverable(context, &sigstruct, msgdata, seckeydata, noncefunc, nil) == 0 {
            throw LotusError.signatureFailed
            }

            var sig = [UInt8](repeating: 0, count: 65)
            var recid: Int32 = 0
            secp256k1_ecdsa_recoverable_signature_serialize_compact(context, &sig, &recid, &sigstruct)
            sig[64] = UInt8(recid) // add back recid to get 65 bytes sig
            return sig
    }
}

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
