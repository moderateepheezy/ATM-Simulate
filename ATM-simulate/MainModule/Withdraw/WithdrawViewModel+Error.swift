//
//  WithdrawViewModel+Error.swift
//  ATM-simulate
//
//  Created by Afees Lawal on 8/8/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import Foundation

extension WithdrawViewModel {
    enum Error: Swift.Error, LocalizedError {
        case invalidInput
        case insufficentBalance
        case noText
        
        var errorDescription: String? {
            switch self {
            case .invalidInput:
                return "You can only withdraw a multiple of 500 or 1000"
                
            case .insufficentBalance:
                return "Insufficient Balance"
                
            case .noText:
                return "Please provide an amount to withdraw"
            }
        }
    }
}

