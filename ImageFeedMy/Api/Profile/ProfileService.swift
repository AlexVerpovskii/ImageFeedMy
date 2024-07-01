//
//  ProfileService.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 01.07.2024.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private var model: ProfileResult?
    private(set) var profile: Profile?
    
    private init() {}
    
    func fetchProfile(completion: @escaping (Swift.Result<ProfileResult, Error>) -> Void) {
        let request = ProfileRequest()
        NetworkApi.shared.sendRequest(request: request, model: model) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let data):
                guard let data = data else { return }
                profile = ProfileConverter.convert(profileResult: data)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(Constants.NetworkError.otherError(error)))
            }
        }
    }
}
