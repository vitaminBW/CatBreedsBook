//
//  AppDelegate.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 18.07.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var dependencyContainer: DependencyContainer!
    private var router: Router!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        dependencyContainer = DependencyContainer()
        
        let navigationController = UINavigationController()
        router = Router(navigationController: navigationController, container: dependencyContainer)
        
        let breedListViewController = router.createBreedListView()
        
        navigationController.viewControllers = [breedListViewController]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

