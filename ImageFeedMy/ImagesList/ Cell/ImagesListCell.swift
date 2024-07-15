//
//  ImagesListCell.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 06.05.2024.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    //MARK: - Static properties
    static let reuseIdentifier = Constants.Other.reuseIdentifier
    
    var photos: [Photo] = []
    
    private lazy var customContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypBlack
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    //MARK: - Public UI elements
    private lazy var cellImage: UIImageView = {
        let cellImage = UIImageView()
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellImage.contentMode = .scaleAspectFill
        cellImage.layer.masksToBounds = true
        cellImage.layer.cornerRadius = 16
        return cellImage
    }()
    
    private lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.addTarget(self, action: #selector(like), for: .touchUpInside)
        return likeButton
    }()
    
    private lazy var dateLabel: UILabel = {
        let datelabel = UILabel()
        datelabel.translatesAutoresizingMaskIntoConstraints = false
        datelabel.font = UIFont.systemFont(ofSize: 13)
        datelabel.textColor = .white
        return datelabel
    }()
    
    //MARK: - Private UI elements
    private lazy var gradientView: UIView = {
        let gradientView = UIView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.layer.cornerRadius = 16
        gradientView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return gradientView
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        let startColor = UIColor.ypGradientStart
        let endColor = UIColor.ypGradientEnd
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        return gradientLayer
    }()
    
    //    MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .ypBlack
    }
    
    required init?(coder: NSCoder) {
        //TODO: Избавиться от строки
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(customContentView)
        customContentView.addSubview(cellImage)
        customContentView.addSubview(likeButton)
        customContentView.addSubview(dateLabel)
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
        customContentView.addSubview(gradientView)
        setupConstraint()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil
        dateLabel.text = nil
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            customContentView.topAnchor.constraint(equalTo: topAnchor),
            customContentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            customContentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            customContentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            cellImage.topAnchor.constraint(equalTo: customContentView.topAnchor),
            cellImage.bottomAnchor.constraint(equalTo: customContentView.bottomAnchor),
            cellImage.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor),
            cellImage.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor),
            
            likeButton.topAnchor.constraint(equalTo: customContentView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            
            gradientView.bottomAnchor.constraint(equalTo: customContentView.bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 30),
            
            dateLabel.bottomAnchor.constraint(equalTo: customContentView.bottomAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: customContentView.trailingAnchor, constant: -8),
        ])
    }
    
    func configCell(for model: ModelImageCell, with indexPath: IndexPath, _ completion: @escaping  () -> Void) {
        cellImage.kf.setImage(with: URL(string: model.photosUrl), placeholder: UIImage(named: Constants.ImageNames.stub)) { _ in
            completion()
        }
        tag = indexPath.row
        dateLabel.text = model.dateText
        likeButton.setImage(UIImage(named: model.isLiked ? Constants.ImageNames.likeOn : Constants.ImageNames.likeOff ), for: .normal)
    }
    
    //TODO: Создать презентер и вынести логику
    @objc
    private func like(_ sender: UIButton) {
        UIBlockingProgressHUD.show()
        let indexPathRow = sender.tag
        var photo = photos[indexPathRow]
        LikeService.shared.fetchLike(liked: !photo.isLiked, photoId: photo.id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                UIBlockingProgressHUD.dismiss()
                likeButton.setImage(UIImage(named: data.photo.likedByUser ? Constants.ImageNames.likeOn : Constants.ImageNames.likeOff ), for: .normal)
                photo.isLiked = data.photo.likedByUser
                photos[indexPathRow] = photo
            case .failure(let error):
                print(error)
                //TODO вынести в логгер
                /*Log.createlog(log: LogModel(serviceName: LikeService.SERVICE_NAME, message: "Ошибка при обработке запроса лайка", systemError: error.localizedDescription, eventType: .error))*/
            }
        }
    }
}
