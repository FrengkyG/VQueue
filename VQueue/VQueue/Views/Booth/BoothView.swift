//
//  BoothView.swift
//  VQueue
//
//  Created by Frengky Gunawan on 21/07/25.
//

import SwiftUI

struct BoothView: View {
    var body: some View {
        ZStack{
            VStack {
                Image("iconBoothLogin")
                    .imageScale(.large)
                    .foregroundColor(Color.primaryColor)
                Text("Hello, world!")
            }
            VStack {
                Spacer()
                Button(action: {
                }){
                    Text("Join Queue")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.redColor)
                        .cornerRadius(12)
                }.padding(.horizontal, 37)
            }.padding(.bottom, 37)
        }
        .padding()
    }
}

#Preview {
    BoothView()
}

