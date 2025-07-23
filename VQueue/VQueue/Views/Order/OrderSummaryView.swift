//
//  OrderSummaryView.swift
//  VQueue
//
//  Created by Frengky Gunawan on 23/07/25.
//

import SwiftUI

struct OrderSummaryView: View {
    @State private var isNavigatingToQueue = false
    
    let orders = [
        Product(
            brand: "MYKONOS",
            name: "Satin Blanc EDP 100 ml",
            price: "Rp 298.000",
            originalPrice: "399.000",
            imageName: "sampleProduct1",
            qty: 2
        ),
        Product(
            brand: "MYKONOS",
            name: "Moroccan Vanilla EDP 100 ml",
            price: "Rp 298.000",
            originalPrice: "399.000",
            imageName: "sampleProduct2",
            qty: 1
        )
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    ToolbarOrderView()
                    Divider().background(Color.dividerColor)
                    Text("Order Summary")
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .padding(.top, 20)
                        .padding(.horizontal, 15)
                    ForEach(orders) { order in
                        OrderItemView(order: order)
                    }
                    Divider().background(Color.dividerColor)
                        .padding(.vertical, 24)
                        .padding(.horizontal, 8)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Note")
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                            .foregroundColor(.redColor)
                        
                        Text("This is only your order summary. Pay at the cashier after you get your queue number! 💸")
                            .font(.system(size: 13  ))
                        
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 20)
                    
                    Rectangle()
                        .fill(Color(hex: "#E5E5E9") ?? Color.gray)
                        .frame(maxHeight: .infinity)
                }
                .background()
                
                Button(action: {
                    isNavigatingToQueue = true
                }){
                    Text("Join Queue")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.redColor)
                        .cornerRadius(12)
                }
                .padding(37)
                .foregroundColor(Color.graysColor)
            }
        }
        .background(Color(hex: "#E5E5E9") ?? Color.gray)
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $isNavigatingToQueue) {
            QueueView()
        }
    }
}

#Preview {
    OrderSummaryView()
}

struct ToolbarOrderView: View {
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "chevron.left")
                .foregroundColor(Color.redColor)
                .fontWeight(.bold)
                .padding(.horizontal, 12)
            
            Text("Mykonos")
                .font(.system(size: 17))
                .fontWeight(.semibold)
            Spacer()
        }.padding(8)
    }
}

struct OrderItemView: View {
    let order: Product
    
    var body: some View {
        HStack(alignment: .top) {
            Image(order.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(order.name)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.black)
                        .lineLimit(2)
                    
                    Text(order.price)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.red)
                    
                    if let originalPrice = order.originalPrice {
                        Text(originalPrice)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.gray)
                            .strikethrough()
                            .baselineOffset(2)
                    }
                }
                Spacer()
                Circle()
                    .stroke(Color.red, lineWidth: 1)
                    .frame(width: 27, height: 27)
                    .overlay(
                        Text("\(order.qty)")
                            .foregroundColor(Color.red)
                            .font(.system(size: 17, weight: .medium))
                    )
            }
        }
        .padding(.horizontal, 15)
        .padding(.top, 20)
    }
}
