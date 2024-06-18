//
//  ViewController.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 02.05.2024.
//

import UIKit

typealias TableProtocols = UITableViewDelegate & UITableViewDataSource

final class ImagesListVC: UIViewController {
    
    //MARK: - Private propierties
    private final let imageListPresenter = ImagesListPresenter()
    
    //MARK: Private UI elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
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
    }
}

//MARK: Implementation table protocols
extension ImagesListVC: TableProtocols {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let image = UIImage(named: imageListPresenter.photosName[indexPath.row]),
            let singleImageVC = SingleImageVC(image: image)
        else {
            return
        }
        singleImageVC.modalPresentationStyle = .fullScreen
        present(singleImageVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageListPresenter.photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier) as? ImagesListCell else {
            return UITableViewCell()
        }
        cell.configCell(for: imageListPresenter.converter(indexPath: indexPath), with: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: imageListPresenter.photosName[indexPath.row]) else {
            return 200
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = image.size.width / imageViewWidth
        return image.size.height / scale + imageInsets.top + imageInsets.bottom
    }
}
