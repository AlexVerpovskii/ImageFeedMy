//
//  ImagesListPresenter.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 18.06.2024.
//

import Foundation

final class ImagesListPresenter {
    private static let SERVICE_NAME = "ImagesListPresenter"

    var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.Other.dateFormat
        dateFormatter.locale = Locale(identifier: Constants.Other.formatterLocal)
        return dateFormatter
    }()
    
    func imageConverter(indexPath: IndexPath) -> ModelImageCell {
        let dateText = dateFormatter.string(from: Date())
        let photosName = photos[indexPath.row].thumbImageURL
        
        return ModelImageCell(photosUrl: photosName, dateText: dateText)
    }
    
    func createLog(isError: Bool) {
        if isError {
            Log.createlog(log: LogModel(serviceName: ImagesListPresenter.SERVICE_NAME, message: "Ошибка при обработке запроса в методе willDisplay", systemError: nil, eventType: .error))
        } else {
            Log.createlog(log: LogModel(serviceName: ImagesListPresenter.SERVICE_NAME, message: "Получение фотографий новой страницы", systemError: nil, eventType: .info))
        }
    }
}
