//
//  ViewController.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 02.05.2024.
//

import UIKit

typealias TableProtocols = UITableViewDelegate & UITableViewDataSource

final class ImagesListViewController: UIViewController {
    
    //MARK: - Private propierties
    private let photosName: [String] = Array(0..<20).map{ "\($0)"}
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.Other.dateFormat
        dateFormatter.locale = Locale(identifier: Constants.Other.formatterLocal)
        return dateFormatter
    }()
    
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
    
    //MARK: - Private methods
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else { return }
        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        if indexPath.row.isMultiple(of: 2) {
            cell.likeButton.setImage(UIImage(named: Constants.ImageNames.LikeOn), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(named: Constants.ImageNames.LikeOff), for: .normal)
        }
    }
}

//MARK: Implementation table protocols
extension ImagesListViewController: TableProtocols {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier) as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: cell, with: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 200
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = image.size.width / imageViewWidth
        return image.size.height / scale + imageInsets.top + imageInsets.bottom
    }
}
