//
//  PinViewModel.swift
//  ATM-simulate
//
//  Created by Afees Lawal on 8/7/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import Foundation

protocol PinViewModelDelegate {
    func pinViewModel(_ viewModel: PinViewModel)
    func pinViewModel(_ viewModel: PinViewModel, error: Error)
    func pinViewModelCanceled(_ viewModel: PinViewModel)
}

class PinViewModel {
    
    // MARK - Private Properties
    private let userPin = "1234"
    private var tryCount = 0
    
    // MARK - Public Properties
    let delegate = MulticastDelegate<PinViewModelDelegate>()
    
    func confirmPin(pin: String?) {
        guard let pin = pin, !pin.isEmpty else {
            delegate.notify {$0.pinViewModel(self, error: Error.noText) }
            return
        }
        if pin == userPin {
            delegate.notify { $0.pinViewModel(self) }
        } else {
            if tryCount == 2 {
                delegate.notify {$0.pinViewModel(self, error: Error.exceedAttemptLimit)}
                return
            }
            delegate.notify {$0.pinViewModel(self, error: Error.wrongPin)}
            tryCount += 1
        }
    }
    
    func onCanceled() {
        delegate.notify { $0.pinViewModelCanceled(self) } 
    }
    
    func resetTryCount() {
        self.tryCount = 0
    }
}
