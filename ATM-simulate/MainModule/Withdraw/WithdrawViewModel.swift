//
//  WithdrawViewModel.swift
//  ATM-simulate
//
//  Created by Afees Lawal on 8/8/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import Foundation

protocol WithdrawViewModelDelegate {
    func withdrawViewModel(_ viewModel: WithdrawViewModel, amount: Int)
    func withdrawViewModel(_ viewModel: WithdrawViewModel, error: Error)
    func withdrawViewModelCancel(_ viewModel: WithdrawViewModel)
}

class WithdrawViewModel {
    
    private let balance: Int
    
    let delegate = MulticastDelegate<WithdrawViewModelDelegate>()
    
    init(balance: Int) {
        self.balance = balance
    }
    
    func makeWithdraw(amount: String?) {
        
        guard let amount = amount, let floatValue = Int(amount) else {
            delegate.notify { $0.withdrawViewModel(self, error: Error.noText) }
            return
        }
        if floatValue > balance {
            delegate.notify { $0.withdrawViewModel(self, error: Error.insufficentBalance) }
        } else if floatValue % 500 == 0 || floatValue % 1000 == 0 {
            delegate.notify { $0.withdrawViewModel(self, amount: floatValue) }
        } else {
            delegate.notify { $0.withdrawViewModel(self, error: Error.invalidInput) }
        }
    }
    
    func abortTransaction() {
        delegate.notify { $0.withdrawViewModelCancel(self) }
    }
}
