//
//  TestCommon.swift
//  ATM-simulateTests
//
//  Created by Afees Lawal on 8/8/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import Foundation
import XCTest
@testable import ATM_simulate

enum TestError: Error, Equatable {
    case error
    
    static func ==(lhs: TestError, rhs: TestError) -> Bool {
        return true
    }
}

func XCTAssertThrows<T: Error>(file: StaticString = #file, line: UInt = #line, error: T, when closure: () throws -> Void) {
    do {
        try closure()
        XCTFail(file: file, line: line)
        
    } catch let e as T {
        XCTAssertEqual(String(describing: error), String(describing: e), file: file, line: line)
        
    } catch {
        XCTFail(file: file, line: line)
    }
}

extension XCTestExpectation {
    func fulfill<T>(when left: T, equals right: T, file: StaticString = #file, line: UInt = #line) {
        fulfill(when: String(describing: left), equals: String(describing: right), file: file, line: line)
    }
    func fulfill<T: Equatable>(when left: T, equals right: T, file: StaticString = #file, line: UInt = #line) {
        if left == right {
            fulfill()
        } else {
            XCTFail(file: file, line: line)
        }
    }
    func fulfill(file: StaticString = #file, line: UInt = #line, when predicate: () -> Bool) {
        if predicate() {
            fulfill()
        } else {
            XCTFail(file: file, line: line)
        }
    }
}

