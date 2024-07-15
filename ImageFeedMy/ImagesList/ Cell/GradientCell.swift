//
//  GradientCell.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 15.07.2024.
//

import UIKit

final class GradientCell: UITableViewCell {
    
    static let identifier = "GradientCell"
    
    private var gradientSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32, height: ImagesListService.shared.photos[self.tag].size.height)
    }

    private lazy var placeholderImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: Constants.ImageNames.stub)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()

    private lazy var gradientLayer: CAGradientLayer = {
        CAGradientLayer.makeGradientLayerWithAnimation(size: gradientSize)
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .ypBlack
        placeholderImageView.layer.addSublayer(gradientLayer)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        contentView.addSubview(placeholderImageView)
        NSLayoutConstraint.activate([
            placeholderImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            placeholderImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            placeholderImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            placeholderImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
