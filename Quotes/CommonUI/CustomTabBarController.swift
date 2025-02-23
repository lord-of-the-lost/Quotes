//
//  CustomTabBarController.swift
//  Quotes
//
//  Created by Николай Игнатов on 19.02.2025.
//


import UIKit

final class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        customizeTabBarAppearance()
    }
}
// MARK: - Private Methods
private extension CustomTabBarController {
    func setupViewControllers() {
        let vc1 = createNavController(
            image: UIImage(systemName: "bookmark"),
            rootViewController: FavoritesViewController()
        )
        
        let vc2 = createNavController(
            image: UIImage(systemName: "house"),
            rootViewController: MainViewController()
        )
        
        let vc3 = createNavController(
            image: UIImage(systemName: "pencil.and.list.clipboard"),
            rootViewController: FavoritesViewController()
        )
        
        viewControllers = [vc1, vc2, vc3]
        selectedIndex = 1
    }
    
    func customizeTabBarAppearance() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .green
        
        tabBar.itemWidth = 50
        tabBar.itemPositioning = .centered
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 4
    }
    
    func createNavController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.navigationBar.isHidden = true
        navController.tabBarItem.image = image
        return navController
    }
}
