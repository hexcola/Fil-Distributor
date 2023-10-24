//
//  DistributorView.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/20.
//

import SwiftUI

struct DispatchView: View {
    var receiverFilename: String
    var sender: Key
    var receivers: [Receiver]
    private let distributor = Distributor()
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading = false
    
    private var totalFils: Double {
        var t:Double = 0
        for receiver in receivers {
            t += receiver.amount
        }
        return t
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("File: \(receiverFilename)")
                    
                    List(receivers) { receiver in
                        Text("\(receiver.address), \(receiver.amount)")
                    }
                    
                    Text("Total: \(totalFils) FIL")
                        .font(.title)
                        .padding(20)
                        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                    
                    HStack {
                        Button(action: {
                            // Popup loading UI
                            isLoading = true
                            distributor.dispatch(sender: sender, receivers: receivers) { result in
                                isLoading = false
                                // TODO: save the results to local database
                                // Go back to Account page
                                DispatchQueue.main.async {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }, label: {
                            Label("Send", systemImage: "paperplane")
                        })
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                }
                
                if isLoading {
                    ZStack {
                        Color(.systemBackground)
                            .ignoresSafeArea()
                            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .scaleEffect(3)
                    }
                }
            }
        }
    }
}

#Preview {
    // NOTE:
    // If you encounter an error here, add a `DEV_SENDER_ADDRESS`
    // environment variable to Xcode project schema
    // REF: https://m25lazi.medium.com/environment-variables-in-xcode-a78e07d223ed
    DispatchView(receiverFilename:"Example.excel", 
                 sender: Key(from: ProcessInfo.processInfo.environment["DEV_SENDER_PRIVATE_KEY"]!,
                                                               address: ProcessInfo.processInfo.environment["DEV_SENDER_ADDRESS"]!)!,
                 receivers: [
                    Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 1),
                    Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 2),
                    Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 3),
                    Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 4),
                    Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 1),
                    Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 2),
                    Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 3),
                    Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 4),
                    Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 1),
                    Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 2),
                    Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 3),
                    Receiver(address: "f1abcdef12345678901234567890abcdef1234567", amount: 4),
                 ])
}
