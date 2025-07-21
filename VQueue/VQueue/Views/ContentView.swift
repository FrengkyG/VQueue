//
//  ContentView.swift
//  VQueue
//
//  Created by Frengky Gunawan on 18/07/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image("iconBoothLogin")
                .imageScale(.large)
                .foregroundColor(Color.primaryColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
