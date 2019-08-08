//
//  BaseViewController.swift
//  ATM-simulate
//
//  Created by Afees Lawal on 8/7/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import UIKit

/// It also enforces a specific view model be provided upon creation
/// which can be accessed via the .viewModel property
class BaseViewController<ViewModelType>: UIViewController {

    var viewModel: ViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = viewModel else {
            fatalError("Must be initialised by passing a viewModel")
        }
        
    }
    
    // MARK: - Cancel Button Setup
    func setupCancelBarButton() {
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = cancelBarButton
        
    }
    
    @objc func handleCancel() {}
    
}
