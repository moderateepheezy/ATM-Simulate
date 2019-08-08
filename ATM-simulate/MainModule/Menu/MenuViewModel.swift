//
//  MenuViewModel.swift
//  ATM-simulate
//
//  Created by Afees Lawal on 8/8/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import Foundation

protocol MenuViewModelDelegate {
    func menuViewModelBalance(_ viewModel: MenuViewModel)
    func menuViewModelWithdraw(_ viewModel: MenuViewModel)
    func menuViewModelCancel(_ viewModel: MenuViewModel)
}

class MenuViewModel {
    
    let delegate = MulticastDelegate<MenuViewModelDelegate>()
    
    func checkBalance() {
        delegate.notify { $0.menuViewModelBalance(self) }
    }
    
    func makeWithdrawal() {
        delegate.notify { $0.menuViewModelWithdraw(self) }
    }
    
    func abort() {
        delegate.notify { $0.menuViewModelCancel(self) }
    }
}
