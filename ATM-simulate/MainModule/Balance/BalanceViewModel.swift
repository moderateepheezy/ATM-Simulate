//
//  BalanceViewModel.swift
//  ATM-simulate
//
//  Created by Afees Lawal on 8/8/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import Foundation

protocol BalanceViewModelDelegate {
    func balanceViewModelCancelled(_ viewModel: BalanceViewModel)
}

class BalanceViewModel {
    
    let balance: Int
    
    init(balance: Int) {
        self.balance = balance
    }
    
    let delegate = MulticastDelegate<BalanceViewModelDelegate>()
    
    func handleCancel() {
        delegate.notify { $0.balanceViewModelCancelled(self) }
    }
}
