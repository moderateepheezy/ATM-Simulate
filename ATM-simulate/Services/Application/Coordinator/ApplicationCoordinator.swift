//
//  ApplicationCoordinator.swift
//  ATM-simulate
//
//  Created by Afees Lawal on 8/6/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import Foundation
import UIKit

class ApplicationCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    // MARK: Private Properties
    fileprivate var pinContainer: UINavigationController?
    
    //MARK: - Public Properties
    var childCoordinators: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    
    init(rootNavigationController: UINavigationController) {
        self.navigationController = rootNavigationController
    }
    
    func start() {
        showHome()
    }
}

// MARK: - Error Handling
private extension ApplicationCoordinator {
    func handle(title: String = "Error!", error: String, completion: ((UIAlertAction) -> ())? = nil) {
        let alert = UIAlertController(
            title: title,
            message: error,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: completion
        ))
        
        let target = navigationController.visibleViewController ?? navigationController
        target.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Cancel Handling
private extension ApplicationCoordinator {
    func handleCancelableAlert(title: String,  message: String, completion: ((UIAlertAction) -> ())? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        ))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: completion))
        
        let target = navigationController.visibleViewController ?? navigationController
        target.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Routing
extension ApplicationCoordinator {
    
    // Root Controller
    private func showHome() {
        let viewModel = HomeViewModel()
        viewModel.delegate.add(self)
        
        let viewController = HomeViewController.instantiate()
        viewController.viewModel = viewModel
        
        navigationController.delegate = self
        
        UIView.animate(withDuration: navigationController.shouldAnimate ? 0.35 : 0) {
            UIView.setAnimationCurve(.easeInOut)
            self.navigationController.isNavigationBarHidden = false
            self.navigationController.setViewControllers([viewController], animated: self.navigationController.shouldAnimate)
        }
    }
    
    private func showPin() {
        let viewModel = PinViewModel()
        viewModel.delegate.add(self)
        
        let viewController = PinViewController.instantiate()
        viewController.viewModel = viewModel
        let nav = UINavigationController(rootViewController: viewController)
        pinContainer = nav
        navigationController.present(nav, animated: true, completion: nil)
    }
}


// MARK:- HomeViewModelDelegate
extension ApplicationCoordinator: HomeViewModelDelegate {
    func homeViewModel(_ viewModel: HomeViewModel) {
        showPin()
    }
}

// MARK:- PinViewModelDelegate
extension ApplicationCoordinator: PinViewModelDelegate {
    
    func pinViewModel(_ viewModel: PinViewModel) {
        
    }
    
    func pinViewModel(_ viewModel: PinViewModel, error: Error) {
        switch error {
        case PinViewModel.Error.wrongPin:
            handleCancelableAlert(title: "Error", message: error.localizedDescription) {[weak self] _ in
                self?.pinContainer?.dismiss(animated: true, completion: nil)
                viewModel.delegate.removeAll()
                self?.pinContainer = nil
            }
        case PinViewModel.Error.exceedAttemptLimit:
            handle(error: error.localizedDescription) {[weak self] _ in
                self?.pinContainer?.dismiss(animated: true, completion: nil)
                viewModel.delegate.removeAll()
                self?.pinContainer = nil
            }
        case PinViewModel.Error.noText:
            handle(error: error.localizedDescription)
        default:
            handle(error: "Something went wrong!")
        }
    }
    
    func pinViewModelCanceled(_ viewModel: PinViewModel) {
        self.pinContainer?.dismiss(animated: true, completion: nil)
        viewModel.delegate.removeAll()
        self.pinContainer = nil
    }
}

