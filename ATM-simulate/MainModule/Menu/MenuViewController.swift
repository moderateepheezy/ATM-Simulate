//
//  MenuViewController.swift
//  ATM-simulate
//
//  Created by Afees Lawal on 8/8/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController<MenuViewModel>, Storyboarded {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func checkBalance(_ sender: Any) {
        viewModel.checkBalance()
    }
    
    @IBAction func makeWithdrawal(_ sender: Any) {
        viewModel.makeWithdrawal()
    }
    
    
    @IBAction func abortTransaction(_ sender: Any) {
        viewModel.abort()
    }
    
    
}
