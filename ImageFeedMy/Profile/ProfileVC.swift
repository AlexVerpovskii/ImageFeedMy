//
//  ProfileViewController.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 11.06.2024.
//

import UIKit
import Kingfisher

final class ProfileVC: UIViewController {
    
    private lazy var avatarImage: UIImageView = {
        var avatarImage = UIImageView()
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.layer.cornerRadius = avatarImage.bounds.width / 2
        avatarImage.image = UIImage(named: Constants.ImageNames.avatar)
        avatarImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImage.heightAnchor.constraint(equalTo: avatarImage.widthAnchor).isActive = true
        let gradient = CAGradientLayer.makeGradientLayerWithAnimation(size: CGSize(width: 70, height: 70))
        return avatarImage
    }()
    
    private lazy var exitButton: UIButton = {
        var exitButton = UIButton()
        exitButton.accessibilityIdentifier = "logoutButton"
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.setImage(UIImage(named: Constants.ImageNames.exitButtonIcon), for: .normal)
        exitButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        exitButton.heightAnchor.constraint(equalTo: exitButton.widthAnchor).isActive = true
        exitButton.addTarget(self, action: #selector(exitAction), for: .touchUpInside)
        return exitButton
    }()
    
    private lazy var fullNameLabel: UILabel = {
        var fullNameLabel = UILabel()
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.textColor = .white
        fullNameLabel.text = "Александр Верповский"
        fullNameLabel.font = UIFont.systemFont(ofSize: 23)
        let gradient = CAGradientLayer.makeGradientLayerWithAnimation(size: CGSize(width: 223, height: 20))
        return fullNameLabel
    }()
    
    private lazy var nickNameLabel: UILabel = {
        var nickNameLabel = UILabel()
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        nickNameLabel.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        //TODO: Избавиться от строки
        nickNameLabel.text = "@AVerpovskii"
        nickNameLabel.font = UIFont.systemFont(ofSize: 13)
        let gradient = CAGradientLayer.makeGradientLayerWithAnimation(size: CGSize(width: 89, height: 18))
        return nickNameLabel
    }()
    
    private lazy var greetingLabel: UILabel = {
        var greetingLabel = UILabel()
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        greetingLabel.textColor = .white
        //TODO: Избавиться от строки
        greetingLabel.text = "Hello, world!"
        greetingLabel.font = UIFont.systemFont(ofSize: 13)
        let gradient = CAGradientLayer.makeGradientLayerWithAnimation(size: CGSize(width: 67, height: 18))
        return greetingLabel
    }()
    
    private lazy var infoStackView: UIStackView = {
        var infoStackView = UIStackView(arrangedSubviews: [
            fullNameLabel,
            nickNameLabel,
            greetingLabel
        ])
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .vertical
        infoStackView.spacing = 8
        return infoStackView
    }()
    
    private lazy var avatarStackView: UIStackView = {
        var avatarStackView = UIStackView(arrangedSubviews: [
            avatarImage,
            exitButton
        ])
        avatarStackView.translatesAutoresizingMaskIntoConstraints = false
        avatarStackView.axis = .horizontal
        avatarStackView.alignment = .center
        avatarStackView.distribution = .equalSpacing
        return avatarStackView
    }()
    
    private lazy var baseStackView: UIStackView = {
        var baseStackView = UIStackView(arrangedSubviews: [
            avatarStackView,
            infoStackView
        ])
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        baseStackView.axis = .vertical
        baseStackView.spacing = 8
        return baseStackView
    }()
    
    private final var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        view.addSubview(baseStackView)
        setupConstraint()
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                updateAvatar()
            }
        updateAvatar()
        updateProfileDetails()
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            baseStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            baseStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func updateProfileDetails() {
        guard let profile = ProfileService.shared.profile else { return }
        fullNameLabel.text = profile.name
        nickNameLabel.text = profile.loginName
        print(profile.loginName)
        greetingLabel.text = profile.bio
        [fullNameLabel, nickNameLabel, greetingLabel].forEach { $0.layer.sublayers?.removeAll() }
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        avatarImage.layer.sublayers?.removeAll()
        let processor = RoundCornerImageProcessor(cornerRadius: 70)
        avatarImage.kf.indicatorType = .activity
        avatarImage.kf.setImage(with: url, placeholder: UIImage(named: Constants.ImageNames.stub), options: [.processor(processor)])
    }
    
    @objc
    private func exitAction() {
        //TODO: Создать и вынести в презентер
        showErrorAlert()
    }
    
    //TODO: Создать и вынести в презентер
    private func showErrorAlert() {
        let ac = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        let firstAction = UIAlertAction(title: "Да", style: .default) { action in
            ac.dismiss(animated: true)
            ProfileLogoutService.shared.logout()
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }
            let vc = SplashVC()
            window.rootViewController = vc
            window.makeKeyAndVisible()
        }
        let secondAction = UIAlertAction(title: "Нет", style: .default) { _ in
            ac.dismiss(animated: true)
        }
        firstAction.accessibilityIdentifier = "Yes"
        ac.addAction(firstAction)
        ac.addAction(secondAction)
        present(ac, animated: true)
    }
}
