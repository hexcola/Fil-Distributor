//
//  SplashScreenView.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/23.
//

import SwiftUI

struct SplashScreenView: View {
    @State var isActive: Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var key:Key?
    
    var body: some View {
        if isActive {
            ImportKeyView()
        } else {
            ZStack {
                // background
                Color.blue
                    .ignoresSafeArea()
                
                // forground
                VStack {
                    VStack {
                        Image("filecoin-logo")
                            .resizable()
                            .frame(width: 200, height: 200)
                        Text("Distributor")
                            .font(Font.custom("Baskerville-Bold", size: 26))
                            .foregroundStyle(Color.white.opacity(0.8))
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 0.9
                            self.opacity = 1.00
                        }
                    }
                }
                .background(Color.blue)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
                
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
