//
//  ImagesListPresenter.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 18.06.2024.
//

import Foundation

final class ImagesListPresenter {

    let photosName: [String] = Array(0..<20).map{ "\($0)"}
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.Other.dateFormat
        dateFormatter.locale = Locale(identifier: Constants.Other.formatterLocal)
        return dateFormatter
    }()
    
    func converter(indexPath: IndexPath) -> ModelImageCell {
        let dateText = dateFormatter.string(from: Date())
        let photosName = photosName[indexPath.row]
        
        return ModelImageCell(photosName: photosName, dateText: dateText)
    }
}
