//
//  PinViewModel+Error.swift
//  ATM-simulate
//
//  Created by Afees Lawal on 8/8/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import Foundation

extension PinViewModel {
    enum Error: Swift.Error, LocalizedError {
        case wrongPin
        case exceedAttemptLimit
        case noText
        
        var errorDescription: String? {
            switch self {
            case .wrongPin:
                return "Invalid Card Pin"
                
            case .exceedAttemptLimit:
                return "Your have exceeded the attempt limit.\nYour Card has been seized, please contact your bank."
                
            case .noText:
                return "Please provide your Card pin"
            }
        }
    }
}
