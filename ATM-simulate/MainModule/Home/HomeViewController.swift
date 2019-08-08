//
//  HomeViewController.swift
//  ATM-simulate
//
//  Created by Afees Lawal on 8/6/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController<HomeViewModel>, Storyboarded {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Simulate ATM card insertion and initialization
    @IBAction func insertATM(_ sender: Any) {
        activityIndicator.startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {[weak self] in
            
            self?.activityIndicator.stopAnimating()
            self?.viewModel.setupATMCard()
            
         UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
}
