//
//  MainTabBarController.swift
//  PostPigeon
//
//  Created by Oleksandr Kurtsev on 23/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    private let currentUser: MUser
    
    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = Colors.niceViolet

        let listViewController = ListViewController(currentUser: currentUser)
        let peopleViewController = PeopleViewController(currentUser: currentUser)
        
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        let convImage = UIImage(systemName: kImageSystemConv, withConfiguration: boldConfig)!
        let peopleImage = UIImage(systemName: kImageSystemPeople, withConfiguration: boldConfig)!

        viewControllers = [
            generateNavigationController(rootVC: peopleViewController, title: kTitlePeoples, image: peopleImage),
            generateNavigationController(rootVC: listViewController, title: kTitleConversations, image: convImage)
        ]
    }
    
    private func generateNavigationController(rootVC: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
