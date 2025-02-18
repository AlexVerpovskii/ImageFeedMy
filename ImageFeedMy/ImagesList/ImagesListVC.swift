//
//  ViewController.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 02.05.2024.
//

import UIKit
import Kingfisher

typealias TableProtocols = UITableViewDelegate & UITableViewDataSource

final class ImagesListVC: UIViewController {
    
    //MARK: - Private propierties
    private final let imageListPresenter = ImagesListPresenter()
    private final var imageServiceObserver: NSObjectProtocol?
    private var state: Constants.DisplayState = .loading
    
    //MARK: Private UI elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.register(GradientCell.self, forCellReuseIdentifier: GradientCell.identifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 200
        tableView.backgroundColor = .ypBlack
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        return tableView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        //TODO: подумать
        imageListPresenter.photos = ImagesListService.shared.photos
        
        imageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                updateTableViewAnimated()
            }
    }
    
    private func updateTableViewAnimated() {
        let oldCount = imageListPresenter.photos.count
        let newCount = ImagesListService.shared.photos.count
        imageListPresenter.photos = ImagesListService.shared.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

//MARK: Implementation table protocols
extension ImagesListVC: TableProtocols {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIBlockingProgressHUD.show()
        let photo = imageListPresenter.photos[indexPath.row]
        let singleImageVC = SingleImageVC()
        singleImageVC.imageView.kf.setImage(with: URL(string: photo.largeImageURL)) { [weak self] result in
            guard let self else { return }
            UIBlockingProgressHUD.dismiss()
            present(singleImageVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageListPresenter.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier) as? ImagesListCell else {
            return UITableViewCell()
        }
        state = .loading
        cell.configCell(for: imageListPresenter.imageConverter(indexPath: indexPath), with: indexPath) { [weak self] in
            self?.state = .success
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.photos = imageListPresenter.photos
        
        switch state {
        case .loading:
            let gradientCell = tableView.dequeueReusableCell(withIdentifier: GradientCell.identifier, for: indexPath)
            return gradientCell
        case .success:
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSize = imageListPresenter.photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageSize.size.width / imageViewWidth
        return imageSize.size.height / scale + imageInsets.top + imageInsets.bottom
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row != tableView.indexPathForSelectedRow?.last {
            ImagesListService.shared.fetchPhotosNextPage { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(_):
                    imageListPresenter.createLog(isError: false)
                case .failure(_):
                    imageListPresenter.createLog(isError: true)
                }
            }
        }
    }
}
