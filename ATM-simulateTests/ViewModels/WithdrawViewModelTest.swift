//
//  WithdrawViewModelTest.swift
//  ATM-simulateTests
//
//  Created by Afees Lawal on 8/8/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import XCTest
@testable import ATM_simulate

private class Delegate: WithdrawViewModelDelegate {
    
    typealias OnError = (Error) -> Void
    typealias OnCancel = () -> Void
    typealias OnSuccess = (Int) -> Void
    
    private let onError: OnError
    private let onCancel: OnCancel
    private let onSuccess: OnSuccess
    
    private let userBalance = 30000
    
    
    init(onError: @escaping OnError, onSuccess: @escaping OnSuccess, onCancel: @escaping OnCancel) {
        self.onError = onError
        self.onCancel = onCancel
        self.onSuccess = onSuccess
    }
    
    func withdrawViewModel(_ viewModel: WithdrawViewModel, amount: Int) {
        let total = userBalance - amount
        onSuccess(total)
    }
    
    func withdrawViewModel(_ viewModel: WithdrawViewModel, error: Error) { onError(error) }
    
    func withdrawViewModelCancel(_ viewModel: WithdrawViewModel) { onCancel() }
}

class WithdrawViewModelTest: XCTestCase {
    
    func testWithdrawError() {
        let invalidInput = expectation(description: "invalid Input")
        let insufficientBalance = expectation(description: "Insufficient Balance")
        let nilText = expectation(description: "nil Pin")
        let emptyText = expectation(description: "empty Pin")
        
        var stringError: StringError = .nil
        
        let viewModel = WithdrawViewModel(balance: 30000)
        let delegate = Delegate(onError: { (error) in
            switch error {
            case WithdrawViewModel.Error.noText:
                switch stringError {
                case .nil:
                    nilText.fulfill()
                    stringError = .empty
                case .empty:
                    emptyText.fulfill()
                }
            case WithdrawViewModel.Error.insufficentBalance:
                insufficientBalance.fulfill()
            case WithdrawViewModel.Error.invalidInput:
                invalidInput.fulfill()
            default:
                XCTFail()
            }
        },onSuccess: {_ in
            XCTFail()
        },
          onCancel: { XCTFail() }
        )
        
        viewModel.delegate.add(delegate)
        
        viewModel.makeWithdraw(amount: nil)
        viewModel.makeWithdraw(amount: "")
        viewModel.makeWithdraw(amount: "5080")
        viewModel.makeWithdraw(amount: "300000")
        
         waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testCorrectAmount() {
        let exp = expectation(description: "")
        
        let viewModel = WithdrawViewModel(balance: 30000)
        let delegate = Delegate(onError: { _ in
            XCTFail()
        },onSuccess: { (balance) in
            print(balance)
            exp.fulfill(when: balance, equals: 29000)
        },
          onCancel: { XCTFail() }
        )
        
        viewModel.delegate.add(delegate)
        viewModel.makeWithdraw(amount: "1000")
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testWithdrawalCancelled() {
        let exp = expectation(description: "")
        
        let viewModel = WithdrawViewModel(balance: 30000)
        let delegate = Delegate(onError: { _ in
            XCTFail()
        },onSuccess: { (pin) in
            XCTFail()
        },
          onCancel: { exp.fulfill() }
        )
        
        viewModel.delegate.add(delegate)
        viewModel.abortTransaction()
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
