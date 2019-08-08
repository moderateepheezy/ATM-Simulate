//
//  WithdrawViewController.swift
//  ATM-simulate
//
//  Created by Afees Lawal on 8/8/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import UIKit

class WithdrawViewController: BaseViewController<WithdrawViewModel>, Storyboarded {

    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCancelBarButton()
    }
    
    override func handleCancel() {
        viewModel.abortTransaction()
    }
    
    @IBAction func withdraw(_ sender: Any) {
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {[weak self] in
            self?.activityIndicator.stopAnimating()
            self?.viewModel.makeWithdraw(amount: self?.inputTextField.text)
        }
    }
    
}
