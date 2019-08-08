//
//  MenuViewModelTest.swift
//  ATM-simulateTests
//
//  Created by Afees Lawal on 8/8/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import XCTest
@testable import ATM_simulate

private class Delegate: MenuViewModelDelegate {
    
    typealias OnChecKBalance = (Float) -> Void
    typealias OnMakeWithdrawal = () -> Void
    typealias OnCancel = () -> Void
    
    private let onChecKBalance: OnChecKBalance
    private let onMakeWithdrawal: OnMakeWithdrawal
    private let onCancel: OnCancel
    
    init(onChecKBalance: @escaping OnChecKBalance, onMakeWithdrawal: @escaping OnMakeWithdrawal, onCancel: @escaping OnCancel) {
        self.onChecKBalance = onChecKBalance
        self.onMakeWithdrawal = onMakeWithdrawal
        self.onCancel = onCancel
    }
    
    func menuViewModelBalance(_ viewModel: MenuViewModel) { onChecKBalance(30000.00) }
    
    func menuViewModelWithdraw(_ viewModel: MenuViewModel) { onMakeWithdrawal() }
    
    func menuViewModelCancel(_ viewModel: MenuViewModel) { onCancel() }
}

class MenuViewModelTest: XCTestCase {
    func testCheckBalance() {
        let exp = expectation(description: "")
        let viewModel = MenuViewModel()
        let delegate = Delegate(onChecKBalance: { (balance) in
            exp.fulfill(when: balance, equals: 30000.00)
        }, onMakeWithdrawal: {
            XCTFail()
        }) {
            XCTFail()
        }
        
        viewModel.delegate.add(delegate)
        viewModel.checkBalance()
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testMakeWithdrawal() {
        let exp = expectation(description: "")
        let viewModel = MenuViewModel()
        let delegate = Delegate(onChecKBalance: { _ in
            XCTFail()
        }, onMakeWithdrawal: {
            exp.fulfill()
        }) {
            XCTFail()
        }
        
        viewModel.delegate.add(delegate)
        viewModel.makeWithdrawal()
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testAbort() {
        let exp = expectation(description: "")
        let viewModel = MenuViewModel()
        let delegate = Delegate(onChecKBalance: { _ in
            XCTFail()
        }, onMakeWithdrawal: {
            XCTFail()
        }) {
            exp.fulfill()
        }
        
        viewModel.delegate.add(delegate)
        viewModel.abort()
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
