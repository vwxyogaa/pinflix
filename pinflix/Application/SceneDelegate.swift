//
//  SceneDelegate.swift
//  pinflix
//
//  Created by Panji Yoga on 10/03/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let tabBar = TabBarViewController(nibName: "TabBarViewController", bundle: nil)
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = tabBar.makeTabBar()
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        let tabController = window?.rootViewController as? UITabBarController
        tabController?.tabBar.backgroundColor = .darkGray
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
