//
//  SingleImageViewController.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 16.06.2024.
//

import UIKit

final class SingleImageVC: UIViewController {
    private final var image: UIImage
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.frame.size = image.size
        imageView.contentMode = .scaleAspectFit
        return imageView;
    }()
    
    private lazy var backButton: UIButton = {
        var backButton = UIButton()
        backButton.setImage(UIImage(named: Constants.ImageNames.backwardButton), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return backButton
    }()
    
    private lazy var shareButton: UIButton = {
        var shareButton = UIButton()
        shareButton.setImage(UIImage(named: Constants.ImageNames.sharingButton), for: .normal)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        return shareButton
    }()
    
    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.maximumZoomScale = 1.25
        scrollView.minimumZoomScale = 0.1
        scrollView.delegate = self
        return scrollView
    }()
    
    init?(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(backButton)
        view.addSubview(shareButton)
        setupConstraint()
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),
            
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.heightAnchor.constraint(equalTo: shareButton.widthAnchor),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
    
    @objc
    private func backButtonAction() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapShareButton() {
        let items = [image]
        let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(avc, animated: true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
}
