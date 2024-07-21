//
//  ImageListTests.swift
//  ImageFeedMyTests
//
//  Created by Александр Верповский on 17.07.2024.
//

@testable import ImageFeedMy
import XCTest

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

final class ImageListTests: XCTestCase {
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.Other.dateFormat
        dateFormatter.locale = Locale(identifier: Constants.Other.formatterLocal)
        return dateFormatter
    }()
    
    func testViewControllerCallsViewDidLoad() {
        let imageListPresenter = ImagesListPresenterSpy()
        let listImageVC = ImagesListVC()
        listImageVC.imageListPresenter = imageListPresenter
        let _ = listImageVC.view
        XCTAssertTrue(imageListPresenter.viewDidLoadCalled)
    }
    
    func testPresentImageConverter() {
        let imageListPresenter = ImagesListPresenter()
        let photo = Photo(
            id: "1",
            size: CGSize(width: 100, height: 100),
            thumbImageURL: "thumbImageURL",
            largeImageURL: "largeImageURL",
            isLiked: true
        )
        imageListPresenter.photosArray = [photo]
        let model = imageListPresenter.imageConverter(index: 0)
        XCTAssertTrue(model.isLiked)
        XCTAssertEqual(model.dateText, dateFormatter.string(from: Date()))
        XCTAssertEqual(model.photosUrl, photo.thumbImageURL)
    }
    
    func testFetchPhoto() {
        let imageListPresenter = ImagesListPresenterSpy()
        let listImageVC = ImagesListVC()
        listImageVC.imageListPresenter = imageListPresenter
        let _ = listImageVC.view
        XCTAssertEqual(listImageVC.tableView.numberOfSections, 1)
    }
    
    //TODO: не знаю, что еще можно потестить с контроллером таблицы)
}
