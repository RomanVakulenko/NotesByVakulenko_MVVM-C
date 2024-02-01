//
//  SceneDelegate.swift
//  NotesByVakula
//
//  Created by Roman Vakulenko on 31.01.2024.
//

import UIKit
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mainCoordinator: CoordinatorProtocol?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: scene)
        let mainCoordinator = MainCoordinator()
        window.rootViewController = mainCoordinator.start()

        self.window = window
        self.mainCoordinator = mainCoordinator
        window.makeKeyAndVisible()
    }

}

