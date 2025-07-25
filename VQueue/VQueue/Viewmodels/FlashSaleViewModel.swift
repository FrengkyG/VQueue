//
//  Untitled.swift
//  VQueue
//
//  Created by Frengky Gunawan on 25/07/25.
//
import Foundation
import Combine

class FlashSaleViewModel: ObservableObject {
    @Published var flashSales: [FlashSale] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var segments: [String] = []
    
    func fetchFlashSales(forBoothId boothId: String) {
        isLoading = true
        let urlString = "\(AppConstants.baseLocalUrl)/user/booth/\(boothId)/flashsale"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                        self.isLoading = false
                    }

                    if let error = error {
                        print("❌ Request error:", error)
                        return
                    }

                    if let response = response as? HTTPURLResponse {
                        print("🔁 Status code:", response.statusCode)
                    }

            if let data = data {
                if let raw = String(data: data, encoding: .utf8) {
                                print("📦 Raw response:", raw.prefix(300))
                            }
                
                do {
                    let result = try JSONDecoder().decode(FlashSaleResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.flashSales = result.data
                        self.segments = self.generateSegments(from: result.data)
                        print("✅ Fetched flash sales count:", result.data.count)

                    }
                } catch {
                    print("Decoding error:", error)
                }
            }
        }.resume()
    }
    
    private func generateSegments(from sales: [FlashSale]) -> [String] {
        var segmentSet = Set<String>()
        for sale in sales {
            let label = "\(sale.startTime) - \(sale.endTime)" 
            segmentSet.insert(label)
        }
        return segmentSet.sorted() 
    }
}
