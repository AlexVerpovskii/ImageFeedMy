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
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .ypBlack
        addSubview(cellImage)
        cellImage.addSubview(likeButton)
        cellImage.addSubview(gradientView)
        gradientView.addSubview(dateLabel)
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        //TODO: Избавиться от строки
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
            cellImage.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -4),
            cellImage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cellImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            
            gradientView.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 30),
            
            dateLabel.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: gradientView.trailingAnchor, constant: -8),
        ])
    }

    func configCell(for model: ModelImageCell, with indexPath: IndexPath) {
        cellImage.kf.setImage(with: URL(string: model.photosUrl))
        dateLabel.text = model.dateText
        if indexPath.row.isMultiple(of: 2) {
            likeButton.setImage(UIImage(named: Constants.ImageNames.likeOn), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: Constants.ImageNames.likeOff), for: .normal)
        }
    }
}
