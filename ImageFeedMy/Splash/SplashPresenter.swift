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
            fetchProfile()
        }
    }
    
    private func checkExistsToken() -> Bool {
        let token = OAuth2TokenStorage.shared.token
        return token != nil
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
    
    /**
     TODO: Нужно ли тут все в одну функцию или разделить загрузку профиля и загрузку фото?
     Есть мысль, что фетчить надо ленту, а профиль при переходе в контроллер профиля
     */
    private func fetchProfile() {
        UIBlockingProgressHUD.show()
        ProfileService.shared.fetchProfile { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImage(userName: profile.username) { result in
                    switch result {
                    case .success(_):
                        ImagesListService.shared.fetchPhotosNextPage { result in
                            switch result {
                            case .success(_):
                                UIBlockingProgressHUD.dismiss()
                                self.switchToTabBarController()
                            case .failure(let error):
                                print(error)
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}

extension SplashPresenter: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthVC) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            fetchProfile()
        }
    }
}
