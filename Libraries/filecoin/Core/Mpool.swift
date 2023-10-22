//
//  Mpool.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/21.
//

import Foundation

struct Mpool {
    private let rpcAgent = FilecoinRPCAgent()
    
    func getNonce(sender:String, completion: @escaping(Result<Int, Error>) -> Void) {
        rpcAgent.request(method: FilecoinAPIMethod.mpoolGetNonce, params: [.string(sender)], completion: { result in
            do {
                let response = try JSONDecoder().decode(FilecoinAPIResponseData<Int>.self, from: result.get())
                completion(.success(response.result))
            } catch {
                completion(.failure(NetworkError.parseDataFailed))
                return
            }
        })
    }
    
    func pushMessage(signedMessage:SignedMessage, completion: @escaping(Result<CID, Error>) -> Void) {
        rpcAgent.request(method: FilecoinAPIMethod.mpoolPush, params: [.signedMessage(signedMessage)], completion: { result in
            do {
                let response = try JSONDecoder().decode(FilecoinAPIResponseData<CID>.self, from: result.get())
                completion(.success(response.result))
            } catch {
                completion(.failure(NetworkError.parseDataFailed))
                return
            }
        })
    }
    
    
    /**
     Batch push message to API
     NOTE: API service not support this method directly.
     */
    func batchPushMessage(signedMessages:[SignedMessage], completion: @escaping([CID], Error?) -> Void) {
        let group = DispatchGroup()
        var responseDataArray: [CID] = []
        let serialQueue = DispatchQueue(label: "PushMessage")
        var catchedError: Error?
        
        for message in signedMessages {
            group.enter()
            
            pushMessage(signedMessage: message, completion: {result in
                serialQueue.sync {
                    do {
                        try responseDataArray.append(result.get())
                        group.leave()
                    } catch {
                        catchedError = error
                        group.leave()
                        return
                    }
                }
            })
        }
        
        group.notify(queue: DispatchQueue.global()) {
            completion(responseDataArray, catchedError)
        }
//        rpcAgent.request(method: FilecoinAPIMethod.mpoolBatchPush, params: [.signedMessageArray(signedMessages)], completion: { result in
//            
//            print("-------------------------------------------------------")
//            print(result)
//            print("-------------------------------------------------------")
//            do {
//                let response = try JSONDecoder().decode(FilecoinAPIResponseData<[CID]>.self, from: result.get())
//                completion(.success(response.result))
//            } catch {
//                completion(.failure(NetworkError.parseDataFailed))
//                return
//            }
//        })
    }
}
