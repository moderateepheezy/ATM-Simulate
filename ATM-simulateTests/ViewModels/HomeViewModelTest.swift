//
//  HomeViewModelTest.swift
//  ATM-simulateTests
//
//  Created by Afees Lawal on 8/8/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import XCTest
@testable import ATM_simulate

private class Delegate: HomeViewModelDelegate {

    typealias OnFinish = () -> Void
    
    private let onFinish: OnFinish
    
    init(onFinish: @escaping OnFinish) {
        self.onFinish = onFinish
    }
    
    func homeViewModel(_ viewModel: HomeViewModel) { onFinish() }
}

class HomeViewModelTest: XCTestCase {

    func testFinishInitializingATMCard() {
        let exp = expectation(description: "")
        
        let viewModel = HomeViewModel()
        let delegate = Delegate {
            exp.fulfill()
        }
        
        viewModel.delegate.add(delegate)
        viewModel.setupATMCard()
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }

}
