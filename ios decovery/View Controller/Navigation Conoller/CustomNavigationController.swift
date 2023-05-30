//
//  CustomNavigationController.swift
//  ios decovery
//
//  Created by Ray Chow on 24/5/2023.
//

import Foundation
import UIKit


class CustomNavigationController: UINavigationController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        (UserDefaultsStore.shared.isDarkMode ?? false) ? .lightContent : .darkContent
    }
}
