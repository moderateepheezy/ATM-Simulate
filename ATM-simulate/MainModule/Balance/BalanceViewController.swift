//
//  BalanceViewController.swift
//  ATM-simulate
//
//  Created by Afees Lawal on 8/8/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import UIKit

class BalanceViewController: BaseViewController<BalanceViewModel>, Storyboarded {

    @IBOutlet weak var balanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCancelBarButton()
        
        balanceLabel.text = "N\(viewModel.balance)"
    }

    override func handleCancel() {
        viewModel.handleCancel()
    }
}
