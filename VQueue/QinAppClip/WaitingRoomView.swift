//
//  WaitingRoomView.swift
//  VQueue
//
//  Created by Frengky Gunawan on 24/07/25.
//

import SwiftUI

struct WaitingRoomView: View {
    var body: some View {
        VStack {
            Image("logoJxb2025")
            Rectangle()
                .fill(Color.black)
                .frame(height: 1)
                .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 2)
            
            Image("flashSaleNotStarted")
                .padding(.top, 15)
            
            
            Button(action: {
                // TODO: HANDLE STATE
            }){
                Text("Choose Your Item")
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical,20)
                    .background(Color.grayDarkerColor)
                    .cornerRadius(10)
            }
            .padding(.top, 19)
            .foregroundColor(.grayDarkerColor)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 8)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("for better experience,")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#747274"))
                    Spacer()
                }
                
                Text("Download our virtual queue App")
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                
                Button(action: {
                    // TODO: Download
                }){
                    Text("Q-in Aja")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.redColor)
                        .cornerRadius(9)
                }.padding(.top, 9)
            }.padding(.top, 25)
        }
        .padding(.horizontal, 50)
    }
}

#Preview {
    WaitingRoomView()
}
