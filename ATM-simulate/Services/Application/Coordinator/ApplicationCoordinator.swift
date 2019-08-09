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
    fileprivate var platformContainer: UINavigationController?
    fileprivate var balanceContainer: UINavigationController?
    fileprivate var withdrawContainer: UINavigationController?
    fileprivate var userBalance: Int = 30000
    
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
    func handle(title: String = "Error!", message: String, completion: ((UIAlertAction) -> ())? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
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
    func handleCancelableAlert(title: String,  message: String, completion: ((UIAlertAction) -> ())? = nil, cancelledCompletion: ((UIAlertAction) -> ())? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: completion
        ))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: cancelledCompletion))
        
        let target = navigationController.visibleViewController ?? navigationController
        target.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Print Receipt Handling
private extension ApplicationCoordinator {
    func handleReceiptAlert(okCompletion: ((UIAlertAction) -> ())? = nil,
                            cancelCompletion: ((UIAlertAction) -> ())? = nil) {
        handleCancelableAlert(title: "Print Receipt", message: "Will you like to print the receipt of this transaction?", completion: okCompletion, cancelledCompletion: cancelCompletion)
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
    
    // Pin Controller
    private func showPin() {
        let viewModel = PinViewModel()
        viewModel.delegate.add(self)
        
        let viewController = PinViewController.instantiate()
        viewController.viewModel = viewModel
        let nav = UINavigationController(rootViewController: viewController)
        pinContainer = nav
        navigationController.present(nav, animated: true, completion: nil)
    }
    
    // Platform Controller
    private func showPlatformTransaction() {
        let viewModel = MenuViewModel()
        viewModel.delegate.add(self)
        
        let viewController = MenuViewController.instantiate()
        viewController.viewModel = viewModel
        let nav = UINavigationController(rootViewController: viewController)
        platformContainer = nav
        navigationController.present(nav, animated: true, completion: nil)
    }
    
    // Balance Controller
    private func showBalance() {
        let viewModel = BalanceViewModel(balance: userBalance)
        viewModel.delegate.add(self)
        
        let viewController = BalanceViewController.instantiate()
        viewController.viewModel = viewModel
        let nav = UINavigationController(rootViewController: viewController)
        balanceContainer = nav
        navigationController.present(nav, animated: true, completion: nil)
    }
    
    // Withdraw Controller
    private func showWithdrawal() {
        let viewModel = WithdrawViewModel(balance: userBalance)
        viewModel.delegate.add(self)
        
        let viewController = WithdrawViewController.instantiate()
        viewController.viewModel = viewModel
        let nav = UINavigationController(rootViewController: viewController)
        withdrawContainer = nav
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
        self.pinContainer?.dismiss(animated: true, completion: nil)
        viewModel.delegate.removeAll()
        self.pinContainer = nil
        showPlatformTransaction()
    }
    
    func pinViewModel(_ viewModel: PinViewModel, error: Error) {
        switch error {
        case PinViewModel.Error.wrongPin:
            handleCancelableAlert(title: "Error", message: error.localizedDescription, completion: nil)  {[weak self] _ in
                self?.pinContainer?.dismiss(animated: true, completion: nil)
                viewModel.delegate.removeAll()
                self?.pinContainer = nil
            }
        case PinViewModel.Error.exceedAttemptLimit:
            handle(message: error.localizedDescription) {[weak self] _ in
                self?.pinContainer?.dismiss(animated: true, completion: nil)
                viewModel.delegate.removeAll()
                self?.pinContainer = nil
            }
        case PinViewModel.Error.noText:
            handle(message: error.localizedDescription)
        default:
            handle(message: "Something went wrong!")
        }
    }
    
    func pinViewModelCanceled(_ viewModel: PinViewModel) {
        self.pinContainer?.dismiss(animated: true, completion: nil)
        viewModel.delegate.removeAll()
        self.pinContainer = nil
    }
}

// MARK:- MenuViewModelDelegate
extension ApplicationCoordinator: MenuViewModelDelegate {
    func menuViewModelBalance(_ viewModel: MenuViewModel) {
        self.platformContainer?.dismiss(animated: true, completion: nil)
        viewModel.delegate.removeAll()
        self.platformContainer = nil
        
        showBalance()
    }
    
    func menuViewModelWithdraw(_ viewModel: MenuViewModel) {
        self.platformContainer?.dismiss(animated: true, completion: nil)
        viewModel.delegate.removeAll()
        self.platformContainer = nil
        
        showWithdrawal()
    }
    
    func menuViewModelCancel(_ viewModel: MenuViewModel) {
        self.platformContainer?.dismiss(animated: true, completion: nil)
        viewModel.delegate.removeAll()
        self.platformContainer = nil
    }
}

// MARK:- MenuViewModelDelegate
extension ApplicationCoordinator: BalanceViewModelDelegate {
    func balanceViewModelCancelled(_ viewModel: BalanceViewModel) {
        
        handleReceiptAlert(okCompletion: {[weak self] (_) in
            guard let self = self else {return}
            let receipt = "Date: \(Date())\nMachine Location: Yaba\nTransaction Type: Balance\nAccount: 0121293940\nAvailable Balance: \(self.userBalance)"
            self.handle(title: "Receipt", message: receipt, completion: {[weak self] (_) in
                
                self?.handleCancelableAlert(title: "Transaction Cancelled", message: "Do you want to perform another transaction?", completion: {[weak self] (_) in
                    self?.balanceContainer?.dismiss(animated: true, completion: nil)
                    viewModel.delegate.removeAll()
                    self?.balanceContainer = nil
                    
                    self?.showPin()
                    }, cancelledCompletion: {[weak self] (_) in
                        self?.balanceContainer?.dismiss(animated: true, completion: nil)
                        viewModel.delegate.removeAll()
                        self?.balanceContainer = nil
                })
                
            })
        }) {[weak self] (_) in
            self?.balanceContainer?.dismiss(animated: true, completion: nil)
            viewModel.delegate.removeAll()
            self?.balanceContainer = nil
        }
    }
}

// MARK:- WithdrawViewModelDelegate
extension ApplicationCoordinator: WithdrawViewModelDelegate {
    func withdrawViewModel(_ viewModel: WithdrawViewModel, amount: Int) {
        
        self.userBalance = userBalance - amount
        
        handle(title: "Withdraw Successful", message: "") {[weak self] (_) in
            self?.handleReceiptAlert(okCompletion: {[weak self] (_) in
                guard let self = self else { return }
                let receipt = "Date: \(Date())\nMachine Location: Yaba\nTransaction Type: Debit\nAmount: \(amount)\nAccount: 0121293940\nAvailable Balance: \(self.userBalance)"
                self.handle(title: "Receipt", message: receipt, completion: {[weak self] (_) in
                    
                    self?.handleCancelableAlert(title: "Transaction Completed", message: "Do you want to perform another transaction?", completion: {[weak self] (_) in
                        self?.withdrawContainer?.dismiss(animated: true, completion: nil)
                        viewModel.delegate.removeAll()
                        self?.withdrawContainer = nil
                        
                        self?.showPin()
                        }, cancelledCompletion: {[weak self] (_) in
                            self?.withdrawContainer?.dismiss(animated: true, completion: nil)
                            viewModel.delegate.removeAll()
                            self?.withdrawContainer = nil
                    })
                    
                    
                })
            }) {[weak self] (_) in
                self?.handleCancelableAlert(title: "Transaction Completed", message: "Do you want to perform another transaction?", completion: {[weak self] (_) in
                    self?.withdrawContainer?.dismiss(animated: true, completion: nil)
                    viewModel.delegate.removeAll()
                    self?.withdrawContainer = nil
                    
                    self?.showPin()
                    }, cancelledCompletion: {[weak self] (_) in
                        self?.withdrawContainer?.dismiss(animated: true, completion: nil)
                        viewModel.delegate.removeAll()
                        self?.withdrawContainer = nil
                })
            }
        }
    }
    
    func withdrawViewModel(_ viewModel: WithdrawViewModel, error: Error) {
        handle(message: error.localizedDescription)
    }
    
    func withdrawViewModelCancel(_ viewModel: WithdrawViewModel) {
        self.handleCancelableAlert(title: "Transaction Cancelled", message: "Do you want to perform another transaction?", completion: {[weak self] (_) in
            self?.withdrawContainer?.dismiss(animated: true, completion: nil)
            viewModel.delegate.removeAll()
            self?.withdrawContainer = nil
            
            self?.showPin()
            }, cancelledCompletion: {[weak self] (_) in
                self?.withdrawContainer?.dismiss(animated: true, completion: nil)
                viewModel.delegate.removeAll()
                self?.withdrawContainer = nil
        })
    }
}
