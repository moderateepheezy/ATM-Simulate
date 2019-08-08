//
//  BalanceViewModelTest.swift
//  ATM-simulateTests
//
//  Created by Afees Lawal on 8/8/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import XCTest
@testable import ATM_simulate

private class Delegate: BalanceViewModelDelegate {
    
    typealias OnCancel = () -> Void
    
    private let onCancel: OnCancel
    
    init(onCancel: @escaping OnCancel) {
        self.onCancel = onCancel
    }
    
    func balanceViewModelCancelled(_ viewModel: BalanceViewModel) {
        onCancel()
    }
}

class BalanceViewModelTest: XCTestCase {
    func testCancel() {
        let exp = expectation(description: "")
        let viewModel = BalanceViewModel(balance: 30000)
        let delegate = Delegate {
            exp.fulfill()
        }
        viewModel.delegate.add(delegate)
        viewModel.handleCancel()
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
