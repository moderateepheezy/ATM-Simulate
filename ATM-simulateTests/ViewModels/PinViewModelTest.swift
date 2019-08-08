//
//  PinViewModelTest.swift
//  ATM-simulateTests
//
//  Created by Afees Lawal on 8/7/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import XCTest
@testable import ATM_simulate

private class Delegate: PinViewModelDelegate {
    
    typealias OnError = (Error) -> Void
    typealias OnCancel = () -> Void
    typealias OnSuccess = (String) -> Void
    
    private let onError: OnError
    private let onCancel: OnCancel
    private let onSuccess: OnSuccess
    
    init(onError: @escaping OnError, onSuccess: @escaping OnSuccess, onCancel: @escaping OnCancel) {
        self.onError = onError
        self.onCancel = onCancel
        self.onSuccess = onSuccess
    }

    func pinViewModel(_ viewModel: PinViewModel) { onSuccess("1234") }
    
    func pinViewModel(_ viewModel: PinViewModel, error: Error) { onError(error) }
    
    func pinViewModelCanceled(_ viewModel: PinViewModel) { onCancel() }
}

enum StringError {
    case `nil`, empty
}

class PinViewModelTest: XCTestCase {

    func testErrorPin() {
        let wrongPin = expectation(description: "Wrong Pin")
        let exceedLimit = expectation(description: "Exceed Try Limit")
        let nilText = expectation(description: "nil Pin")
        let emptyText = expectation(description: "empty Pin")
        
        var stringError: StringError = .nil
        
        let viewModel = PinViewModel()
        let delegate = Delegate(onError: { (error) in
            switch error {
            case PinViewModel.Error.noText:
                switch stringError {
                case .nil:
                    nilText.fulfill()
                    stringError = .empty
                case .empty:
                    emptyText.fulfill()
                }
            case PinViewModel.Error.wrongPin:
                wrongPin.expectedFulfillmentCount = 3
                wrongPin.fulfill()
            case PinViewModel.Error.exceedAttemptLimit:
                exceedLimit.fulfill()
                print("")
            default:
                 XCTFail()
            }
        },onSuccess: {_ in
            XCTFail()
        },
          onCancel: { XCTFail() }
        )
        
        viewModel.delegate.add(delegate)
        viewModel.confirmPin(pin: nil)
        viewModel.confirmPin(pin: "")
        
        viewModel.resetTryCount()
        viewModel.confirmPin(pin: "0000")
        
        viewModel.resetTryCount()
        viewModel.confirmPin(pin: "0000")
        viewModel.confirmPin(pin: "0000")
        viewModel.confirmPin(pin: "0000")
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testCorrectPin() {
        let exp = expectation(description: "")
        
        let viewModel = PinViewModel()
        let delegate = Delegate(onError: { _ in
            XCTFail()
        },onSuccess: { (pin) in
            exp.fulfill(when: pin, equals: "1234")
        },
          onCancel: { XCTFail() }
        )
        
        viewModel.delegate.add(delegate)
        viewModel.confirmPin(pin: "1234")
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testPinCancelled() {
        let exp = expectation(description: "")
        
        let viewModel = PinViewModel()
        let delegate = Delegate(onError: { _ in
            XCTFail()
        },onSuccess: { (pin) in
            XCTFail()
        },
          onCancel: { exp.fulfill() }
        )
        
        viewModel.delegate.add(delegate)
        viewModel.onCanceled()
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
