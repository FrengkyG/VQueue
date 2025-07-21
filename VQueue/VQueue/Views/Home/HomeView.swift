//
//  WelcomeView.swift
//  VQueue
//
//  Created by Frengky Gunawan on 21/07/25.
//

import SwiftUI

struct HomeView: View {
    @State private var scannedResult: String?
    @State private var isPresentingScanner = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image("iconBoothLogin")
            }
            
            Spacer()
            
            if let result = scannedResult {
                Text("QR Result:\n\(result)")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
        
            Button(action: {
                isPresentingScanner = true
            }
            ){
                Text("Start Scan")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.redColor)
                    .cornerRadius(12)
            }.padding(.horizontal, 20)
        }
        .padding(.horizontal, 36)
        .padding(.top, 20)
        .padding(.bottom, 85)
        .fullScreenCover(isPresented: $isPresentingScanner) {
            QrScanView { result in
                scannedResult = result
                isPresentingScanner = false
            }
        }
    }
}

#Preview {
    HomeView()
}

