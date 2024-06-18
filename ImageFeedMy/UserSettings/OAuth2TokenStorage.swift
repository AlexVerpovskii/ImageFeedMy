//
//  OAuth2TokenStorage.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 18.06.2024.
//

import Foundation

typealias Keys = Constants.SettingsKeys
final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private let userDefaults = UserDefaults.standard
    
    var token: String {
        get { userDefaults.string(forKey: Keys.token.rawValue) ?? Constants.Other.empty}
        set { userDefaults.set(newValue, forKey: Keys.token.rawValue)}
    }
}
