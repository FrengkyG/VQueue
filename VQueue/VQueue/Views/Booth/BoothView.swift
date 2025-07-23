//
//  BoothView.swift
//  VQueue
//
//  Created by Frengky Gunawan on 21/07/25.
//

import SwiftUI

struct BoothView: View {
    @State private var isNavigatingToOrderSummary = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ToolbarSearchView()
                Divider().background(Color.dividerColor)
                BoothInfoView()
                FlashSaleSegmentedView()
                ProductGridView()
                
                Button(action: {
                    isNavigatingToOrderSummary = true
                }){
                    Text("Join Queue")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.redColor)
                        .cornerRadius(12)
                }.padding(.horizontal, 37)
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $isNavigatingToOrderSummary) {
                OrderSummaryView()
            }
        }
    }
}

#Preview {
    BoothView()
}


struct ToolbarSearchView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "chevron.left")
                .foregroundColor(Color.redColor)
                .fontWeight(.bold)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.iconGrayColor)
                
                TextField("Search", text: $searchText)
                    .disableAutocorrection(true)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.grayColor)
            .cornerRadius(100)
            .padding(.horizontal, 8)
            
            Image(systemName: "cart.fill")
                .foregroundColor(Color.redColor)
        }.padding(8)
    }
}

struct BoothInfoView: View {
    var body: some View {
        HStack {
            Image("sampleBrandLogo")
                .resizable()
                .scaledToFill()
                .frame(width: 56, height: 56)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.secondaryColor ?? Color.pink, lineWidth: 1)
                )
            
            VStack(alignment: .leading) {
                Text("Mykonos")
                    .fontWeight(.semibold)
                    .font(.system(size: 17))
                
                HStack(spacing: 4) {
                    Image("iconLocation")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                    
                    Text("Hall Cendrawasih")
                        .font(.system(size: 15))
                        .foregroundStyle(Color.graysColor ?? Color.gray)
                }
            }
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
    }
}

struct FlashSaleSegmentedView: View {
    @State private var selectedSegment: String = "Flash Sale Now"
    
    let segments = ["Flash Sale Now", "15:00 - 16:00", "19:00 - 20:00"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(segments, id: \.self) { segment in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        selectedSegment = segment
                    }
                }) {
                    Text(segment)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(selectedSegment == segment ? .white : .black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(selectedSegment == segment ? Color.redColor : Color.clear)
                }.buttonStyle(.plain)
                
                if segment != segments.last {
                    Capsule()
                        .fill(Color.dividerColor ?? Color.gray)
                        .frame(width: 1, height: 20)
                }
            }
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal, 12)
    }
}


struct ProductGridView: View {
    @State private var products: [Product] = [
        Product(
            brand: "MYKONOS",
            name: "Satin Blanc EDP 100 ml",
            price: "Rp 298.000",
            originalPrice: "399.000",
            imageName: "sampleProduct1"
        ),
        Product(
            brand: "MYKONOS",
            name: "Moroccan Vanilla EDP 100 ml",
            price: "Rp 298.000",
            originalPrice: "399.000",
            imageName: "sampleProduct2"
        ),
        Product(
            brand: "MYKONOS",
            name: "Aphrodite EDP 50 ml",
            price: "Rp 164.000",
            originalPrice: "229.000",
            imageName: "sampleProduct3"
        ),
        Product(
            brand: "MYKONOS",
            name: "Intimate Affair EDP 100 ml",
            price: "Rp 298.000",
            originalPrice: "399.000",
            imageName: "sampleProduct4"
        ),
        Product(
            brand: "MYKONOS",
            name: "Sparkling Rosé EDP 100 ml",
            price: "Rp 298.000",
            originalPrice: "399.000",
            imageName: "sampleProduct5"
        ),
        Product(
            brand: "MYKONOS",
            name: "Pink Beach EDP 100 ml",
            price: "Rp 298.000",
            originalPrice: "399.000",
            imageName: "sampleProduct6"
        )
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach($products, id: \.id) { $product in
                    ProductCardView(product: $product)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

struct ProductCardView: View {
    @State private var showAddToCartSheet = false
    @State private var selectedProduct: Product = Product(brand: "", name: "", price: "", originalPrice: "", imageName: "")
    
    @Binding var product: Product
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                Image(product.imageName)
                    .resizable()
                    .scaledToFit()
                
                HStack {
                    Spacer()
                    Button(action: {
                        showAddToCartSheet = true
                        selectedProduct = product
                    }) {
                        Group {
                            if product.qty > 0 {
                                Circle()
                                    .stroke(Color.redColor ?? Color.red, lineWidth: 1)
                                    .frame(width: 27, height: 27)
                                    .overlay(
                                        Text("\(product.qty)")
                                            .foregroundColor(Color.redColor ?? Color.red)
                                            .font(.system(size: 17, weight: .medium))
                                    )
                            } else {
                                Circle()
                                    .fill(Color.redColor ?? Color.red)
                                    .frame(width: 27, height: 27)
                                    .overlay(
                                        Image(systemName: "plus")
                                            .foregroundColor(.white)
                                            .font(.system(size: 17, weight: .bold))
                                    )
                            }
                        }
                    }
                    .padding(.trailing, 8)
                    .padding(.bottom, 8)
                }
                .padding(.top, 12)
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                HStack {
                    Text(product.price)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.redColor)
                    
                    Spacer()
                    
                    if let originalPrice = product.originalPrice {
                        Text(originalPrice)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.graysColor)
                            .strikethrough()
                            .baselineOffset(2)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .sheet(isPresented: $showAddToCartSheet) {
                ProductBottomSheetView(isPresented: $showAddToCartSheet, product: $product)
                    .presentationDetents([.fraction(0.75)])
            }
        }
    }
}

struct ProductBottomSheetView: View {
    @Binding var isPresented: Bool
    @State private var quantity = 1
    @Binding var product: Product
    
    var body: some View {
        VStack{
            Capsule()
                .frame(width: 36, height: 5)
                .foregroundColor(Color(hex: "#BFBFBF"))
                .padding(.top, 6)
            
            Image(product.imageName)
                .resizable()
                .scaledToFit()
            
            HStack {
                VStack(alignment: .leading) {
                    Text(product.name)
                        .font(.body)
                    
                    HStack(alignment: .top, spacing: 8) {
                        Text(product.price)
                            .font(.system(size: 17))
                            .foregroundColor(.redColor)
                        
                        Text(product.originalPrice ?? "")
                            .font(.system(size: 16))
                            .foregroundColor(.graysColor)
                            .strikethrough()
                            .baselineOffset(1)
                    }
                }
                Spacer()
            }
            
            HStack(spacing: 39) {
                Button(action: {
                    if quantity > 1 {
                        quantity -= 1
                    }
                }) {
                    Circle()
                        .fill(Color.redColor ?? Color.red)
                        .opacity(0.7)
                        .frame(width: 27, height: 27)
                        .overlay(
                            Image(systemName: "minus")
                                .foregroundColor(.white)
                                .font(.system(size: 17, weight: .medium))
                        )
                }
                
                Text("\(quantity)")
                
                Button(action: {
                    quantity += 1
                }) {
                    Circle()
                        .fill(Color.redColor ?? Color.red)
                        .frame(width: 27, height: 27)
                        .overlay(
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 17, weight: .medium))
                        )
                }
            }
            .padding(.vertical, 24)
            
            Button(action: {
                product.qty = quantity
                isPresented = false
            }) {
                Text("Add Items")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.redColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(20)
        .ignoresSafeArea(edges: .bottom)
        .padding(.horizontal, 16)
        .onAppear {
            quantity = max(1, product.qty)
        }
    }
}
