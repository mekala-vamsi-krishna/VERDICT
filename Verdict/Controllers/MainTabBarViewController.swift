//
//  ViewController.swift
//  Verdict
//
//  Created by Mekala Vamsi Krishna on 23/12/22.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: UpComingViewController())
        let vc4 = UINavigationController(rootViewController: TopRatedViewController())
        let vc5 = UINavigationController(rootViewController: ProfileViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc3.tabBarItem.image = UIImage(systemName: "play.circle")
        vc4.tabBarItem.image = UIImage(systemName: "star.circle")
        vc5.tabBarItem.image = UIImage(systemName: "person.crop.circle.fill")
        
        vc1.title = "Home"
        vc2.title = "Search"
        vc3.title = "Up Coming"
        vc4.title = "Top Rated"
        vc5.title = "Profile"
        
        
        tabBar.tintColor = .white
        
        setViewControllers([vc1, vc2, vc3, vc4, vc5], animated: true)
    }


}
