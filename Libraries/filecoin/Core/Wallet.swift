//
//  Wallet.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/21.
//

import Foundation
import secp256k1
import Blake2

struct Wallet {
    private let rpcAgent = FilecoinRPCAgent()
    private var accounts = [Account]()
    
    func balance(sender:String, completion: @escaping(Result<Double, Error>) -> Void) {
        rpcAgent.request(method: FilecoinAPIMethod.walletBalance, params: [.string(sender)], completion: { result in
            do {
                let rsx = try JSONDecoder().decode(FilecoinAPIResponseData<String>.self, from: result.get())
                completion(.success((rsx.result as NSString).doubleValue / 1000000000000000000))
            } catch {
                completion(.failure(NetworkError.parseDataFailed))
                return
            }
        })
    }
    
    func sign(accountAddress: String, message:Message) throws -> SignedMessage? {
        // NOTE:
        // If you encounter an error here, add a `DEV_SENDER_PRIVATE_KEY`
        // environment variable to Xcode project schema
        // REF: https://m25lazi.medium.com/environment-variables-in-xcode-a78e07d223ed
        // TODO: find secret key for account address
        let pk = ProcessInfo.processInfo.environment["DEV_SENDER_PRIVATE_KEY"]!
        guard let pkData = pkToBytes(pk: pk) else {
            return nil
        }
        
        // cid(from the second letter) to bytes
        guard let msgData = message.cid?.bytes() else {
            return nil
        }
        
        // blake2sum
        let b2sum = blake2bSum256(msg: Data(msgData))
        do {
            let sig = try sign(msg: [UInt8](b2sum!), seckey: [UInt8](pkData))
            let signedMessage = SignedMessage(message: message, signature: Signature(type: 1, data: sig))
            return signedMessage
        } catch {
            throw error
        }
    }
    
    private func blake2bSum256(msg:Data) -> Data? {
        do {
            let hash = try! Blake2b.hash(size: 32, data: msg)
            return hash
        } catch {
            return nil
        }
    }
    
    private func pkToBytes(pk: String) -> Data?{
        if let data = pk.data(using: .utf8) {
            let byteArray = Data(base64Encoded: data)
            return byteArray
        } else {
            print("faild to convert string to data")
            return nil
        }
    }
    
    private func sign(msg:[UInt8], seckey:[UInt8]) throws -> String {
        //        let context = secp256k1_context_create(1)!
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))!
        
        if msg.count != 32 {
            throw FilecoinError.wrongMessageSize
        }
        
        if seckey.count != 32 {
            throw FilecoinError.wrongPrivateKeySize
        }
        
        let seckeydata = UnsafeMutablePointer(mutating: seckey)
        
        if secp256k1_ec_seckey_verify(context, seckeydata) != 1 {
            throw FilecoinError.invalidPrivateKey
        }
        
        let msgdata = UnsafeMutablePointer(mutating: msg)
        let noncefunc = secp256k1_nonce_function_rfc6979
        var sigstruct = secp256k1_ecdsa_recoverable_signature()
        
        if secp256k1_ecdsa_sign_recoverable(context, &sigstruct, msgdata, seckeydata, noncefunc, nil) == 0 {
            throw FilecoinError.signatureFailed
        }
        
        var sig = [UInt8](repeating: 0, count: 65)
        var recid: Int32 = 0
        secp256k1_ecdsa_recoverable_signature_serialize_compact(context, &sig, &recid, &sigstruct)
        sig[64] = UInt8(recid) // add back recid to get 65 bytes sig
        
        return Data(sig).base64EncodedString()
    }
    
}
