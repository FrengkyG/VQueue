//
//  BoothView.swift
//  VQueue
//
//  Created by Frengky Gunawan on 21/07/25.
//

import SwiftUI

struct BoothView: View {
    let scannedCode: String
    @State private var isNavigatingToOrderSummary = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ToolbarSearchView()
                Divider().background(Color.dividerColor)
                    .padding(.vertical, 4)
                BoothInfoView(boothId: scannedCode)
                FlashSaleSegmentedView(boothId: scannedCode)
                
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
    BoothView(scannedCode: "c55a8f2a-2ee7-478a-b6df-f7d46ce86e9b")
}


struct ToolbarSearchView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText: String = ""
    
    var body: some View {
        HStack(alignment: .center) {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.redColor)
                    .fontWeight(.bold)
                    .padding(.leading, 12)
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.iconGrayColor)
                
                TextField("Search", text: $searchText)
                    .disableAutocorrection(true)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.grayColor)
            .cornerRadius(100)
            .padding(.horizontal, 8)
            
            Image(systemName: "cart.fill")
                .foregroundColor(Color.redColor)
                .padding(.trailing, 12)
        }
    }
}

struct BoothInfoView: View {
    @StateObject private var viewModel = BoothViewModel()
    var boothId: String
    
    var body: some View {
        HStack {
            if viewModel.isFetchBoothLoading {
                ProgressView("Loading...")
            } else if let booth = viewModel.booth {
                if let imageUrl = booth.imgURL, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 56, height: 56)
                            
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 56, height: 56)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.secondaryColor ?? .pink, lineWidth: 1)
                                )
                            
                        case .failure(_):
                            Image("sampleBrandLogo")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 56, height: 56)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.secondaryColor ?? .pink, lineWidth: 1)
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image("sampleBrandLogo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.secondaryColor ?? .pink, lineWidth: 1)
                        )                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(booth.name)
                        .fontWeight(.semibold)
                        .font(.system(size: 17))
                    
                    HStack(spacing: 4) {
                        Image("iconLocation")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 20)
                        
                        Text(booth.location ?? "Hall A")
                            .font(.system(size: 15))
                            .foregroundStyle(Color.graysColor ?? Color.gray)
                    }
                }
                Spacer()
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else {
                Text("No booth data.")
            }
        }
        .onAppear {
            viewModel.fetchBooth(by: boothId)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
    }
}

struct FlashSaleSegmentedView: View {
    @State private var selectedSegment: String = ""
    @StateObject private var viewModel = FlashSaleViewModel()
    var boothId: String
    
    var body: some View {
        VStack {
            if !viewModel.segments.isEmpty {
                HStack(spacing: 0) {
                    ForEach(viewModel.segments, id: \.self) { segment in
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
                        
                        if segment != viewModel.segments.last {
                            Capsule()
                                .fill(Color.dividerColor ?? Color.gray)
                                .frame(width: 1, height: 20)
                        }
                    }
                }
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal, 12)
                
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxHeight: .infinity)
                } else {
                    ProductGridView(products: filteredProducts)
                        .frame(maxHeight: .infinity)
                }
            }
        }.onAppear {
            viewModel.fetchFlashSales(forBoothId: boothId)
            print("Selected segment on appear:", selectedSegment)
        }
        .onChange(of: viewModel.segments) { segments in
            if selectedSegment.isEmpty, let first = segments.first {
                selectedSegment = first
                print("🎯 Auto-selected first segment:", first)
            }
        }
    }
    
    var filteredProducts: [Product] {
           // Debug: Print semua flash sales yang ada
           print("\n=== DEBUG FLASH SALES ===")
           for (index, sale) in viewModel.flashSales.enumerated() {
               let timeLabel = "\(sale.startTime) - \(sale.endTime)"
               print("FlashSale \(index): \(timeLabel) -> \(sale.products.count) products")
           }
           print("===========================\n")
           
           // Pastikan ada data dan segment yang dipilih
           guard !viewModel.flashSales.isEmpty, !selectedSegment.isEmpty else {
               print("⚠️ No data or no selected segment")
               return []
           }
           
           print("🎯 Looking for segment: '\(selectedSegment)'")
           
           // Coba pendekatan baru: ambil hanya flash sale pertama untuk setiap time segment
           let uniqueFlashSales = Dictionary(grouping: viewModel.flashSales) { sale in
               "\(sale.startTime) - \(sale.endTime)"
           }.compactMapValues { $0.first }
           
           print("🔍 Unique flash sales: \(uniqueFlashSales.keys.sorted())")
           
           // Cari flash sale yang match dengan selected segment
           guard let matchingFlashSale = uniqueFlashSales[selectedSegment] else {
               print("❌ No flash sale found for segment: '\(selectedSegment)'")
               return []
           }
           
           print("✅ Found matching flash sale with \(matchingFlashSale.products.count) products")
           
           // Convert ke Product array
           let products = matchingFlashSale.products.map { Product(from: $0) }
           
           print("📦 Final products count: \(products.count)")
           
           // Debug: Check for duplicate IDs in final products
           let productIds = products.map { $0.id }
           let uniqueIds = Set(productIds)
           if productIds.count != uniqueIds.count {
               print("⚠️ WARNING: Duplicate product IDs detected!")
               print("Total products: \(productIds.count), Unique IDs: \(uniqueIds.count)")
           }
           
           return products
       }
    
    // Fungsi helper untuk mengecek apakah flash sale sedang aktif
    private func isCurrentlyActive(_ flashSale: FlashSale) -> Bool {

        return true
    }
}


struct ProductGridView: View {
    let products: [Product]
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ScrollView {
            if products.isEmpty {
                Text("No products to display")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(products, id: \.id) { product in
                        ProductCardView(product: .constant(product))
                            .onAppear {
                                print("🎴 Rendering product card: \(product.name)")
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
        .onAppear {
            print("📱 ProductGridView appeared with \(products.count) products")
        }
        .onChange(of: products.count) { newCount in
            //                   print("🔄 ProductGridView products count changed: \(newCount) products")
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
