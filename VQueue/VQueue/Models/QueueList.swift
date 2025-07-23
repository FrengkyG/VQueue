//
//  QueueList.swift
//  VQueue
//
//  Created by Frengky Gunawan on 23/07/25.
//
import Foundation

class QueueList: Identifiable {
    let id = UUID()
    let brandName: String
    let location: String
    let currentQueue: Int
    let queueNumber: Int
    
    init(brandName: String, location: String, currentQueue: Int, queueNumber: Int) {
        self.brandName = brandName
        self.location = location
        self.currentQueue = currentQueue
        self.queueNumber = queueNumber
    }
}
