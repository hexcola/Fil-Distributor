//
//  ImportKeyView.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/23.
//

import SwiftUI

struct ImportKeyView: View {
    @State private var filAddress:String = ""
    @State private var filKey:String = ""
    @State private var showAlert = false
    @State private var alertMessage:String = ""
    @State private var isPresented = false
    @State private var importedKey:Key?
    
    var body: some View {
        NavigationStack {
            // background
            ZStack{
                Color.blue
                    .ignoresSafeArea()
                
                // forground
                VStack{
                    // icon
                    VStack {
                        Image("filecoin-logo")
                            .resizable()
                            .frame(width: 200, height: 200)
                        
                        Text("Distributor")
                            .font(Font.custom("Baskerville-Bold", size: 26))
                            .foregroundStyle(Color.white.opacity(0.8))
                    }
                    Spacer()
                    
                    // address
                    TextInputView(title: "Address", hint: "f1 address", height: 50, content: $filAddress)
                    
                    // private key
                    TextInputView(title: "PrivateKey", hint: "exported private key", height: 200, axis: .vertical, content: $filKey)
                    
                    // Save button
                    Button("Save"){
                        // TODO: verify if input values are correct
                        print(filAddress.count)
                        if filAddress.count != 41 {
                            alertMessage = "Address length is incorrect"
                            showAlert = true
                        } else if filKey.count == 0 {
                            alertMessage = "Key should not be empty"
                            showAlert = true
                        } else {
                            if let importKey = Key(from: filKey, address: filAddress) {
                                UserDefaults.standard.set(filKey, forKey: "filKey")
                                UserDefaults.standard.set(filAddress, forKey: "filAddress")
                                self.importedKey = importKey
                                self.isPresented = true
                            } else {
                                self.isPresented = false
                                alertMessage = "The key you entered is incorrect"
                                showAlert = true
                                
                            }
                        }
                    }
                    .frame(width: 360, height: 40)
                    .background(Color.white)
                    .foregroundColor(.blue)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .alert(alertMessage, isPresented: $showAlert) {
                        Button("OK", role: .cancel){}
                    }
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: self.$isPresented ) {
                AccountView(key: importedKey!) .navigationBarBackButtonHidden(true)
            }
        }
    }
}


struct TextInputView: View {
    var title:String
    var hint: String
    var width: CGFloat? = 360
    var height: CGFloat?
    var axis: Axis? = .horizontal
    
    @Binding var content: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, content: {
            Text(title)
                .foregroundStyle(Color.white)
            TextField(
                hint,
                text: $content,
                axis: axis!
            )
            .padding(10)
            .focused($isFocused)
            .onSubmit {
                
            }
            .frame(width: 360, height: height)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
        }).padding(.bottom, 20)
    }
}

#Preview {
    ImportKeyView()
}

