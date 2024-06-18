//
//  SplashVC.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 18.06.2024.
//

import UIKit

final class SplashVC: UIViewController {
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: Constants.ImageNames.vector)
        return imageView
    }()
    
    private final var splashPresenter: SplashPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splashPresenter = SplashPresenter(splashVC: self)
        view.addSubview(imageView)
        view.backgroundColor = .ypBlack
        setupConstraint()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        splashPresenter?.routing()
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
