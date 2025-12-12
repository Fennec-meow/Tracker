//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Kira on 24.04.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        
        // Проверка, показывать ли стартовый экран
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        
        if hasSeenOnboarding {
            // Уже заходили, показать основной интерфейс
            let tabBarController = TabBarController()
            window?.rootViewController = tabBarController
        } else {
            // Первый запуск, показать стартовый экран
            let startViewController = StartViewController()
            startViewController.onboardingCompletionHandler = { [weak self] in
                // После завершения стартового экрана, сохраняем флаг
                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                let tabBarController = TabBarController()
                self?.window?.rootViewController = tabBarController
            }
            window?.rootViewController = startViewController
        }
        
        window?.makeKeyAndVisible()
    }
}
