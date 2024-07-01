//
//  ImagesListConverter.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 01.07.2024.
//

import Foundation

final class PhotoConverter {
    
    static func photoConverter(photoResult: PhotoResult) -> Photo {
        Photo(
            id: photoResult.id,
            size: CGSize(width: Double(photoResult.width), height: Double(photoResult.height)),
            createdAt: Date(),
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.thumb,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.likedByUser
        )
    }
}
