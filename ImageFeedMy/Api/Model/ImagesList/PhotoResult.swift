//
//  PhotoResult.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 01.07.2024.
//

import Foundation

struct BasePhoto: Decodable {
    let photo: PhotoResult
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let width, height: Int
    let likedByUser: Bool
    let description: String?
    let urls: Urls

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height
        case likedByUser = "liked_by_user"
        case urls
        case description
    }
}

struct Urls: Decodable {
    let raw, full, regular, small: String
    let thumb: String
}
