//
//  HistoryView.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/22.
//

import SwiftUI

struct HistoryView: View {
    @State private var selectedSegment = 0
    var body: some View {
        
        VStack {
            Picker("Tabs", selection: $selectedSegment) {
                Text("Out").tag(0)
                Text("Failed").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if selectedSegment == 0 {
                HistoryListView()
            } else {
                Text("Second View")
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    HistoryView()
}

struct HistoryListView: View {
    var body: some View {
        ScrollView {
            ForEach(0..<20) { index in
                HStack {
                    // icon
                    Image(systemName: "arrow.up.circle")
                    
                    HStack {
                        VStack(alignment: .trailing, content: {
                            // address
                            Text("f1abcdef12345678901234567890abcdef1234567")
                                .font(.system(size: 10))
                            Text("2023-10-23")
                                .font(.system(size: 10))
                                .fontWeight(.thin)
                            
                            Rectangle()
                                .frame(height: 0.5)
                        })
                        
                        
                        // amount
                        Text("100.0")
                    }
                }
                .frame(width: 350, height: 40)
            }
        }
    }
}
