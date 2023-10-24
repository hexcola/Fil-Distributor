//
//  ExcelHandlerView.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/20.
//

import SwiftUI

struct ExcelHandlerView: View {
    @State private var documentPickerPresented: Bool = false
    var callback: ([Receiver]?, String, Error?) -> Void
    
    var body: some View {
        VStack {
            Button("Select Receiver File") {
                self.documentPickerPresented.toggle()
            }
            .frame(width: 200, height: 40)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(5)
            
            .fileImporter(
                isPresented: $documentPickerPresented,
                allowedContentTypes: [.spreadsheet],
                allowsMultipleSelection: false) { result in
                    do {
                        let selectedFile = try result.get().first
                        
                        if let selectedFileName = selectedFile?.lastPathComponent,
                           let selectedFilePath = selectedFile?.path(percentEncoded: false) {
                            // Handle the selected file URL as needed
                            let handler = ExcelHandler()
                            print("Selected file URL: \(selectedFile?.absoluteString ?? "")")
                            
                            let receivers = handler.parseExcel(filename: selectedFilePath)
                            
                            if receivers != nil && !receivers!.isEmpty {
                                callback(receivers, selectedFileName, nil)
                            } else {
                                callback(nil, "", ExcelHandleError.formatNotCorrectError)
                            }
                        }else {
                            callback(nil, "", ExcelHandleError.selectedError)
                        }
                    } catch {
                        print("File picking failed: \(error.localizedDescription)")
                    }
                }
        }
    }
}

#Preview {
    ExcelHandlerView(callback: { receivers, selectedFileName, err in
        // Here we do nothing
    })
}
