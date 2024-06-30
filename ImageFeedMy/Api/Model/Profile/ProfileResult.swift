//
//  ProfileResult.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 01.07.2024.
//

struct ProfileResult: Decodable {
    let username, firstName, lastName:String
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}
