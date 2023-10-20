//
//  ExcelHandlerView.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/20.
//

import SwiftUI

struct ExcelHandlerView: View {
    @State private var documentPickerPresented: Bool = false
    @State private var selectedURL: URL?
//    @State private var receivers: [Receiver]?
    var callback: ([Receiver]?) -> Void
    
    var body: some View {
        VStack {
            Button("Open File") {
                self.documentPickerPresented.toggle()
            }
            .fileImporter(
                isPresented: $documentPickerPresented,
                allowedContentTypes: [.spreadsheet],
                allowsMultipleSelection: false) { result in
                    do {
                        let selectedFile = try result.get().first
                        self.selectedURL = selectedFile
                        // Handle the selected file URL as needed
                        let handler = ExcelHandler()
                        print("Selected file URL: \(selectedFile?.absoluteString ?? "")")
                        let receivers = handler.parseExcel(filename: selectedFile!.path(percentEncoded: false))
                        callback(receivers)
                    } catch {
                        print("File picking failed: \(error.localizedDescription)")
                    }
            }
            
            if let selectedURL = selectedURL {
                Text("Selected file: \(selectedURL.lastPathComponent)")
            }
        }
    }
}

#Preview {
    ExcelHandlerView(callback: { receivers in
    // Here we do nothing
    })
}
