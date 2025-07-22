//
//  Product.swift
//  VQueue
//
//  Created by Frengky Gunawan on 22/07/25.
//
import Foundation

class Product: ObservableObject, Identifiable {
    let id = UUID()
    let brand: String
    let name: String
    let price: String
    let originalPrice: String?
    let imageName: String
    
    @Published var qty: Int

    init(
        brand: String,
        name: String,
        price: String,
        originalPrice: String? = nil,
        imageName: String,
        qty: Int = 0
    ) {
        self.brand = brand
        self.name = name
        self.price = price
        self.originalPrice = originalPrice
        self.imageName = imageName
        self.qty = qty
    }
}
