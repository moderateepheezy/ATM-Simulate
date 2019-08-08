//
//  PinViewController.swift
//  ATM-simulate
//
//  Created by Afees Lawal on 8/7/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import UIKit

class PinViewController: BaseViewController<PinViewModel>, Storyboarded {

    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCancelBarButton()
        
    }
    
    @IBAction func comfirmPin(_ sender: Any) {
        viewModel.confirmPin(pin: pinTextField.text)
    }
    
    override func handleCancel() {
        viewModel.onCanceled()
    }
}
