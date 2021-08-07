//
//  MainViewController.swift
//  Mobile App
//
//  Created by flavio on 07/08/21.
//

import Foundation
import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.backgroundImage = UIImage(color: UIColor.white)
        tabBar.shadowImage = UIImage(color: UIColor(named: "topaz")!, size: CGSize(width: 1, height: 0.5))
    }
}
