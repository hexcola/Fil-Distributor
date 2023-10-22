//
//  Gas.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/21.
//

import Foundation

struct MaxFee:Codable {
    let maxFee: String
    
    init(maxFee: String = "0") {
        self.maxFee = maxFee
    }
    
    enum CodingKeys: String, CodingKey {
        case maxFee = "MaxFee"
    }
}

struct Gas {
    private let rpcAgent = FilecoinRPCAgent()
    
    func estimateMessageGas(message: Message, maxFee: MaxFee, cids:[CID], completion: @escaping(Result<Message, Error>) -> Void) {
        rpcAgent.request(method: FilecoinAPIMethod.gasEstimateMessageGas,
                         params: [.message(message), .maxFee(maxFee), .cidArray(cids)],
                         completion: { result in
            do {
                let response = try JSONDecoder().decode(FilecoinAPIResponseData<Message>.self, from: result.get())
                completion(.success(response.result))
            } catch {
                completion(.failure(NetworkError.parseDataFailed))
                return
            }
        })
    }
    
    func batchEstimateMessageGas(messages: [Message], maxFee: MaxFee, cids:[CID], completion: @escaping(Result<[Message], Error>) -> Void) {
        
        // update message: gasLimit, gasFeeCap, gasPremium, CID
        let group = DispatchGroup()
        var responseDataArray: [Message] = []
        let serialQueue = DispatchQueue(label: "GetCIDsQueue")
        var catchedError:Error?
        
        for message in messages {
            group.enter()
            
            estimateMessageGas(message: message, maxFee: maxFee, cids: cids) { result in
                // Use a serial queue for thread safety
                serialQueue.sync {
                    do {
                        print(message.nonce)
                        print(message.value)
                        print(result)
                        try responseDataArray.append(result.get())
                        group.leave()
                    } catch {
                        // If there's already an error, don't process further
                        catchedError = error
                        group.leave()
                        return
                    }
                }
            }
        }
        
        // Notify when all tasks are completed
        group.notify(queue: DispatchQueue.global()) {
            if let error = catchedError {
                print(error)
                completion(.failure(error))
            } else {
                var sortedMessages = responseDataArray
                sortedMessages.sort{ $0.nonce < $1.nonce }
                completion(.success(sortedMessages))
                return
            }
        }
    }
}
