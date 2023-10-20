//
//  BalanceView.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/20.
//

import SwiftUI

struct ReqData: Codable {
    var jsonrpc = "2.0"
    var method: String
    var params = [String]()
    var id: Int
    
    init(method:String, id:Int, accountAddress:String){
        self.method = "Filecoin.\(method)"
        self.id = id
        self.params.append(accountAddress)
    }
}

struct ResData: Codable {
    var jsonrpc = "2.0"
    var result: String
    var id: Int
    
    func getResult() -> Double {
        return (result as NSString).doubleValue / 1000000000000000000
    }
}

struct BalanceView: View {
    
    @Binding var accountAddress: String
    @State var accountBalance: Double = 0
    
    var body: some View {
        Text("Account: \(accountAddress)")
        
        // Display
        Text("Balance: \(accountBalance)").onAppear {
            loadAccountBalance()
        }
    }
    
    func loadAccountBalance() {
        // Send Http Req
        let url = URL(string: "https://api.node.glif.io/rpc/v0")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
        // Construct http body
        let reqData = ReqData(method: "WalletBalance", id: 1, accountAddress: accountAddress)
        let jsonData = try! JSONEncoder().encode(reqData)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
            } else if let data = data {
                do {
                    let resData = try JSONDecoder().decode(ResData.self, from: data)
                    print(resData)
                    accountBalance = resData.getResult()
                } catch {
                    print("Address incorrect")
                }
                
            } else {
                print("WTF")
            }
        }
        
        task.resume()
    }
}

#Preview {
    BalanceView(accountAddress: .constant("f1abcdef12345678901234567890abcdef1234567"))
}
