//
//  SplashPresenter.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 18.06.2024.
//

import Foundation
import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthVC)
}

final class SplashPresenter {
    
    private final weak var splashVC: SplashVC?
    
    init(splashVC: SplashVC) {
        self.splashVC = splashVC
    }
    
    func routing() {
        if !checkExistsToken() {
            splashVC?.present(configAuthVC(), animated: true)
        } else {
            switchToTabBarController()
        }
    }
    
    private func checkExistsToken() -> Bool {
        let token = OAuth2TokenStorage.shared.token
        return token.isEmpty ? false : true
    }
    
    private func configAuthVC() -> UINavigationController {
        let authVC = AuthVC(authVCDelegate: self)
        let navigationVC = UINavigationController(rootViewController: authVC)
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .ypBlack
        navigationVC.navigationBar.standardAppearance = navigationBarAppearance
        navigationVC.modalPresentationStyle = .fullScreen
        return navigationVC
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            //TODO: Избавиться от строки
            assertionFailure("Invalid window configuration")
            return
        }
        
        let rootTabBarVC = RootTabBarVC()
        window.rootViewController = rootTabBarVC
    }
}

extension SplashPresenter: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthVC) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.switchToTabBarController()
        }
    }
}
