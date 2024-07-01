//
//  AuthPresenter.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 18.06.2024.
//

import Foundation

protocol WebViewVCDelegate {
    func webViewVC(_ vc: WebViewVC, didAuthenticateWithCode code: String)
    func webViewVCDidCancel(_ vc: WebViewVC)
}

final class AuthPresenter {
    
    private final weak var authVC: AuthVC?
    private final var authVCDelegate: AuthViewControllerDelegate
    
    init(authVCDelegate: AuthViewControllerDelegate, authVC: AuthVC) {
        self.authVCDelegate = authVCDelegate
        self.authVC = authVC
    }
}

extension AuthPresenter: WebViewVCDelegate {
    
    func webViewVC(_ vc: WebViewVC, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(_):
                guard let authVC else { return }
                authVCDelegate.didAuthenticate(authVC)
            case .failure(let error):
                authVC?.showErrorAlert()
                print(error)
            }
        }
    }
    
    func webViewVCDidCancel(_ vc: WebViewVC) {
        vc.dismiss(animated: true)
    }
    
    
}
