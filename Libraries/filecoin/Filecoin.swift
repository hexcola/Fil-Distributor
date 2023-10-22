//
//  Filecoin.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/21.
//

import Foundation


enum FilecoinAPIMethod:String, Codable {
    case walletBalance = "Filecoin.WalletBalance"
    
    // Gas
    case gasEstimateMessageGas = "Filecoin.GasEstimateMessageGas"
    
    // Mpool
    case mpoolPush = "Filecoin.MpoolPush"
    case mpoolBatchPush = "Filecoin.MpoolBatchPush"
    case mpoolGetNonce = "Filecoin.MpoolGetNonce"
    
}

enum FilecoinAPIParam: Codable {
    case int(Int)
    case string(String)
    case message(Message)
    case maxFee(MaxFee)
    case cidArray([CID])
    case signedMessage(SignedMessage)
    case signedMessageArray([SignedMessage])
    
    // Add other cases as needed for different types
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let messageValue = try? container.decode(Message.self) {
            self = .message(messageValue)
        } else if let maxFeeValue = try? container.decode(MaxFee.self) {
            self = .maxFee(maxFeeValue)
        } else if let cidArrayValue = try? container.decode([CID].self) {
            self = .cidArray(cidArrayValue)
        } else if let signedMessageValue = try? container.decode(SignedMessage.self) {
            self = .signedMessage(signedMessageValue)
        } else if let signedMessageArrayValue = try? container.decode([SignedMessage].self) {
            self = .signedMessageArray(signedMessageArrayValue)
        }
        else {
            // Handle other types or throw an error
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unsupported type in params array"
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .int(let intValue):
            try container.encode(intValue)
        case .string(let stringValue):
            try container.encode(stringValue)
            // Add other cases as needed for different types
        case .message(let messageValue):
            try container.encode(messageValue)
        case .maxFee(let maxFeeValue):
            try container.encode(maxFeeValue)
        case .cidArray(let cidArrayValue):
            try container.encode(cidArrayValue)
        case .signedMessage(let signedMessageValue):
            try container.encode(signedMessageValue)
        case .signedMessageArray(let signedMessageArrayValue):
            try container.encode(signedMessageArrayValue)
        }
    }
}

struct FilecoinAPIRequestData: Codable {
    var jsonrpc = "2.0"
    var method: FilecoinAPIMethod
    var params: [FilecoinAPIParam]
    var id: Int
    
    init(method:FilecoinAPIMethod, params: [FilecoinAPIParam], id:Int = 1){
        self.method = method
        self.id = id
        self.params = params
    }
}

struct FilecoinAPIResponseData<T:Decodable>: Decodable {
    var jsonrpc = "2.0"
    var result: T
    var id: Int
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case parseDataFailed
    // Add more error cases as needed
}

struct FilecoinRPCAgent {
    let apiEndpoint = "https://api.node.glif.io/rpc/v0"
    
    func request(method: FilecoinAPIMethod, params: [FilecoinAPIParam], completion: @escaping(Result<Data, Error>) -> Void){
        let url = URL(string: apiEndpoint)!
        var agent = URLRequest(url: url)
        agent.httpMethod = "POST"
        
        // Set HTTP Request Header
        agent.setValue("application/json", forHTTPHeaderField: "Accept")
        agent.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let reqData = FilecoinAPIRequestData(method: method, params: params)
        let jsonData = try! JSONEncoder().encode(reqData)
        let jsonString = String(data: jsonData, encoding: .utf8)
        print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
        print(jsonString)
        print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
        
        agent.httpBody = jsonData
        
        URLSession.shared.dataTask(with: agent){ (data, response, error) in
            if let error = error {
                print("************ reqeust error  ****************")
                print(error)
                print("************ reqeust error  ****************")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.requestFailed))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}


struct Filecoin {
    let unit:Double = 1000000000000000000
    let mpool = Mpool()
    let wallet = Wallet()
    let gas = Gas()
}
