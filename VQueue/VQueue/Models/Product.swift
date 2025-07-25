//
//  Product.swift
//  VQueue
//
//  Created by Frengky Gunawan on 22/07/25.
//
import Foundation

import Foundation

class Product: ObservableObject, Identifiable {
    let id: String
    let brand: String
    let name: String
    let price: String
    let originalPrice: String?
    let imageName: String

    @Published var qty: Int

    init(
        id: String = UUID().uuidString,
        brand: String,
        name: String,
        price: String,
        originalPrice: String? = nil,
        imageName: String,
        qty: Int = 0
    ) {
        self.id = id
        self.brand = brand
        self.name = name
        self.price = price
        self.originalPrice = originalPrice
        self.imageName = imageName
        self.qty = qty
    }

    /// Convenience init from FlashSaleProduct
    convenience init(from flashProduct: FlashSaleProduct) {
        self.init(
            id: flashProduct.id,
            brand: "", // Ganti jika tersedia di API
            name: flashProduct.name,
            price: "Rp \(flashProduct.afterFlashsalePrice.currencyFormatted)",
            originalPrice: "Rp \(flashProduct.price.currencyFormatted)",
            imageName: flashProduct.imgURL ?? "sampleProduct1",
            qty: 0
        )
    }
}

struct FlashSaleResponse: Codable {
    let code: Int
    let message: String
    let data: [FlashSale]
}

struct FlashSale: Codable, Identifiable {
    let id: String
    let name: String
    let boothID: String
    let date: String
    let startTime: String
    let endTime: String
    let queueEarlyAccessTime: String
    let flashsaleActiveUTC: String
    let flashsaleInactiveUTC: String
    let products: [FlashSaleProduct]

    enum CodingKeys: String, CodingKey {
        case id, name, date, products
        case boothID = "booth_id"
        case startTime = "start_time"
        case endTime = "end_time"
        case queueEarlyAccessTime = "queue_early_access_time"
        case flashsaleActiveUTC = "flashsale_active_utc"
        case flashsaleInactiveUTC = "flashsale_inactive_utc"
    }
}

struct FlashSaleProduct: Codable, Identifiable {
    let id: String
    let name: String
    let imgURL: String?
    let price: String
    let afterFlashsalePrice: String
    let boothID: String
    let createdAt: String
    let updatedAt: String
    let flashsaleProducts: FlashSaleProductDetails

    enum CodingKeys: String, CodingKey {
        case id, name, price
        case imgURL = "img_url"
        case afterFlashsalePrice = "after_flashsale_price"
        case boothID = "booth_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case flashsaleProducts = "flashsale_products"
    }
}

struct FlashSaleProductDetails: Codable {
    let isSoldOut: Bool

    enum CodingKeys: String, CodingKey {
        case isSoldOut = "is_sold_out"
    }
}

extension String {
    var currencyFormatted: String {
        if let intValue = Int(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = "."
            return formatter.string(from: NSNumber(value: intValue)) ?? self
        }
        return self
    }
}
