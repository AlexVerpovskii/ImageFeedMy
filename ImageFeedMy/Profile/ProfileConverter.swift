//
//  converter.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 01.07.2024.
//

import Foundation

struct ProfileConverter {
    static func convert(profileResult: ProfileResult) -> Profile {
        let name = "\(profileResult.firstName) \(profileResult.lastName)"
        return Profile(
            username: profileResult.username,
            name: name,
            loginName: "@ \(profileResult.username)",
            bio: profileResult.bio ?? ""
        )
    }
}
