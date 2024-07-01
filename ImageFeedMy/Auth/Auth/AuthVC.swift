//
//  AuthVC.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 16.06.2024.
//

import UIKit

final class AuthVC: UIViewController {
    
    private final var authPresenter: WebViewVCDelegate?
    private final var authVCDelegate: AuthViewControllerDelegate
    
    init(authVCDelegate: AuthViewControllerDelegate) {
        self.authVCDelegate = authVCDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        //TODO: Избавиться от строки
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var enterButton: UIButton = {
        var enterButton = UIButton()
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.setTitle("Войти", for: .normal)
        enterButton.setTitleColor(.black, for: .normal)
        enterButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        enterButton.layer.cornerRadius = 16
        enterButton.backgroundColor = .white
        enterButton.addTarget(self, action: #selector(enterAction), for: .touchUpInside)
        return enterButton
    }()
    
    private lazy var logoImageView: UIImageView = {
        var logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: Constants.ImageNames.logo)
        return logoImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(enterButton)
        view.addSubview(logoImageView)
        view.backgroundColor = .ypBlack
        setupConstraint()
        configureBackButton()
        authPresenter = AuthPresenter(authVCDelegate: authVCDelegate, authVC: self)
    }
    
    func showErrorAlert() {
        let ac = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor),
            
            enterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            enterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            enterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            enterButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc
    private func enterAction() {
        guard let authPresenter else { return }
        let webViewVC = WebViewVC(webViewVCDelegate: authPresenter)
        navigationController?.pushViewController(webViewVC, animated: true)
        navigationController?.modalPresentationStyle = .fullScreen
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: Constants.ImageNames.backwardButton)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: Constants.ImageNames.backwardButton)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
}
