//
//  Distributor.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/20.
//

import Foundation
import Blake2
import secp256k1

struct Distributor {
    private let filecoin = Filecoin()
    
    func packMessages(sender: Account, receivers: [Receiver], startNonce: Int) -> [Message] {
        var messages = [Message]()
        var nonce = startNonce
        receivers.forEach { r in
            let value = Int(round(r.amount * filecoin.unit))
            print("Send \(r.address): \(r.amount)  -> \(value)")
            
            var message = Message(from: sender.address, to: r.address, value: String(value), params: nil)
            message.setNonce(nonce)
            messages.append(message)
            nonce += 1
        }
        return messages
    }
    
    func signMessages(sender: Account, messages: [Message])throws -> [SignedMessage]{
        var signedMessages = [SignedMessage]()
        // to get signature
        for message in messages {
            do {
                let signedMessage = try filecoin.wallet.sign(accountAddress: sender.address, message: message)
                signedMessages.append(signedMessage!)
            } catch {
                throw error
            }
        }
        return signedMessages
    }
    
    
    func dispatch(sender: Account, receivers: [Receiver]) {
        filecoin.mpool.getNonce(sender: sender.address, completion: { result in
            let nonce = try! result.get()
            
            let messages = packMessages(sender: sender, receivers: receivers, startNonce: nonce)
            
            self.filecoin.gas.batchEstimateMessageGas(messages: messages, maxFee: MaxFee(), cids: [], completion: { result in
                do {
                    let response = try result.get()
                    let signedMessages = try signMessages(sender: sender, messages: response)
                    
                    // push to mpool
                    self.filecoin.mpool.batchPushMessage(signedMessages: signedMessages, completion: { cids, error in
                        if error != nil {
                            print(error)
                        }
                        for cid in cids {
                            print(cid.value)
                        }
                    })
                } catch {
                    print(error)
                }
            })
        })
    }
    
    func send(fromAccount: Account, receivers: [Receiver]) {
        receivers.forEach { r in
            print("Send \(r.address): \(r.amount)")
        }
        // NOTE:
        // If you encounter an error here, add a `DEV_RECEIVER_ADDRESS`
        // environment variable to Xcode project schema
        // REF: https://m25lazi.medium.com/environment-variables-in-xcode-a78e07d223ed
        var message = Message(from: fromAccount.address, to: ProcessInfo.processInfo.environment["DEV_RECEIVER_ADDRESS"]!, value: "1000000000000000", params: nil)
        
        
        filecoin.mpool.getNonce(sender: fromAccount.address, completion: { result in
            let nonce = try! result.get()
            message.setNonce(nonce)
            
            let jsonEncoder = JSONEncoder()
            if let jsonData = try? jsonEncoder.encode(message),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Encoded JSON: \(jsonString)")
                
                
                // Estimate message gas
                self.filecoin.gas.estimateMessageGas(message: message, maxFee: MaxFee(), cids: [], completion: { result in
                    do {
                        let response = try result.get()
                        // to get signature
                        guard let signedMessage = try self.filecoin.wallet.sign(accountAddress: fromAccount.address, message: response) else {
                            return
                        }
                        
                        // push message to mpool
                        self.filecoin.mpool.pushMessage(signedMessage: signedMessage, completion: { result in
                            
                            do {
                                let cid2 = try result.get()
                                print(cid2)
                            } catch {
                                print(error)
                            }
                            
                        })
                        // encode to JSON
                        if let xjsonData = try? jsonEncoder.encode(signedMessage),
                           let xjsonString = String(data: xjsonData, encoding: .utf8) {
                            print(xjsonString)
                        }
                    } catch {
                        print(error)
                    }
                    
                })
            }
        })
    }
}
