//
//  ImagesListService.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 01.07.2024.
//

import Foundation

final class ImagesListService {
    private static let SERVICE_NAME = "ImagesListService"
    
    static var shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    private var model: [PhotoResult] = []
    private var workItem: DispatchWorkItem?
    
    func fetchPhotosNextPage(completion: @escaping (Swift.Result<[Photo], Error>) -> Void) {
        workItem?.cancel()
        let nextPage = (lastLoadedPage ?? 0) + 1
        let request = ImagesListRequest(page: String(nextPage))
        workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            
            NetworkApi.shared.sendRequest(request: request, model: model) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let data):
                    data.forEach({ photo in
                        self.photos.append(PhotoConverter.photoConverter(photoResult: photo))
                    })
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: nil)
                    completion(.success(photos))
                case .failure(let error):
                    completion(.failure(Constants.NetworkError.otherError(error)))
                    Log.createlog(log: LogModel(serviceName: ImagesListService.SERVICE_NAME, message: "Ошибка при обработке запроса на получение фотографий", systemError: error.localizedDescription, eventType: .error))
                }
            }
        }
        lastLoadedPage = nextPage
        if let workItem = workItem { DispatchQueue.global().async(execute: workItem) }
    }
}
