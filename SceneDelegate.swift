//
//  SceneDelegate.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 02.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let vc = SplashVC()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}

