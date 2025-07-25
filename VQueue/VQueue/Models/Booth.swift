//
//  Booth.swift
//  VQueue
//
//  Created by Frengky Gunawan on 25/07/25.
//
import Foundation

struct BoothResponse: Codable {
    let code: Int
    let message: String
    let data: Booth
}

struct Booth: Codable, Identifiable {
    let id: String
    let name: String
    let description: String?
    let imgURL: String?
    let location: String?
    let userID: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, description, location
        case imgURL = "img_url"
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
