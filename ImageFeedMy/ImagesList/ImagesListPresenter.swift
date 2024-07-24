//
//  ImagesListPresenter.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 18.06.2024.
//

import Foundation

protocol ImagesListPresenterProtocol {
    var photos: [Photo] { get }
    func fetchPhoto()
    func imageConverter(index: Int) -> ModelImageCell
    func createLog(isError: Bool)
}

final class ImagesListPresenter {
    private static let SERVICE_NAME = "ImagesListPresenter"

    var photosArray: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.Other.dateFormat
        dateFormatter.locale = Locale(identifier: Constants.Other.formatterLocal)
        return dateFormatter
    }()
    
    func imageConverter(index: Int) -> ModelImageCell {
        let photo = photos[index]
        let dateText = dateFormatter.string(from: photo.createdAt ?? Date())
        let photosName = photo.thumbImageURL
        
        return ModelImageCell(photosUrl: photosName, dateText: dateText, isLiked: photos[index].isLiked)
    }
    
    func createLog(isError: Bool) {
        if isError {
            Log.createlog(log: LogModel(serviceName: ImagesListPresenter.SERVICE_NAME, message: "Ошибка при обработке запроса в методе willDisplay", systemError: nil, eventType: .error))
        } else {
            Log.createlog(log: LogModel(serviceName: ImagesListPresenter.SERVICE_NAME, message: "Получение фотографий новой страницы", systemError: nil, eventType: .info))
        }
    }
}

extension ImagesListPresenter: ImagesListPresenterProtocol {
    var photos: [Photo] {
        return photosArray
    }
    
    func fetchPhoto() {
        photosArray = ImagesListService.shared.photos
    }
}
