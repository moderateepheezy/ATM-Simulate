//
//  UIViewController+Extension.swift
//  Sivvar
//
//  Created by Afees Lawal on 7/25/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideNavBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}
