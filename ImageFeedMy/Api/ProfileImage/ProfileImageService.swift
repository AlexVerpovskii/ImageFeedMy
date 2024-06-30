//
//  ProfileImageService.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 01.07.2024.
//

import Foundation

final class ProfileImageService {
    static var shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private (set) var avatarURL: String?
    private var model: UserResult?
    
    private init() {}
    
    func fetchProfileImage(userName: String, completion: @escaping (Swift.Result<String, Error>) -> Void) {
        let request = ProfileImageRequest(userName: userName)
        
        NetworkApi.shared.sendRequest(request: request, model: model) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                guard let data else { return }
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": data.profileImage as Any])
                avatarURL = data.profileImage?.large
                completion(.success(data.profileImage?.large ?? ""))
            case .failure(let error):
                completion(.failure(Constants.NetworkError.otherError(error)))
            }
        }
    }
}
