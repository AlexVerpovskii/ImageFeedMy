//
//  LikeService.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 10.07.2024.
//

import Foundation

final class LikeService {
    
    private static let SERVICE_NAME = "LikeService"
    
    static var shared = LikeService()
    
    private var model: BasePhoto?
    private var workItem: DispatchWorkItem?
    
    func fetchLike(liked: Bool, photoId: String, completion: @escaping (Swift.Result<BasePhoto, Error>) -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            let request = liked ? LikeRequest(id: photoId) : Dislike(id: photoId)
            NetworkApi.shared.sendRequest(request: request, model: model) { result in
                switch result {
                case .success(let data):
                    guard let data else { return }
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(Constants.NetworkError.otherError(error)))
                    Log.createlog(log: LogModel(serviceName: LikeService.SERVICE_NAME, message: "Ошибка при обработке запроса лайка", systemError: error.localizedDescription, eventType: .error))
                }
            }
        }
        if let workItem = workItem { DispatchQueue.global().async(execute: workItem) }
    }
}
