//
//  ImagesListPresenterSpy.swift
//  ImageFeedMyTests
//
//  Created by Александр Верповский on 25.07.2024.
//

@testable import ImageFeedMy
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    
    var photos: [Photo] = []
    var viewDidLoadCalled = false
    
    func fetchPhoto() {
        photos.append(Photo(
            id: "1",
            size: CGSize(width: 100, height: 100),
            thumbImageURL: "thumbImageURL",
            largeImageURL: "largeImageURL",
            isLiked: true
        ))
        viewDidLoadCalled = true
    }
    
    func imageConverter(index: Int) -> ImageFeedMy.ModelImageCell {
        return ModelImageCell(photosUrl: "photosUrl", dateText: "dateText", isLiked: false)
    }
    
    func createLog(isError: Bool) {
        
    }
    
    
}
