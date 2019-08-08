//
//  HomeViewModel.swift
//  ATM-simulate
//
//  Created by Afees Lawal on 8/7/19.
//  Copyright © 2019 Afees Lawal. All rights reserved.
//

import Foundation
import UIKit

protocol HomeViewModelDelegate {
    func homeViewModel(_ viewModel: HomeViewModel)
}

class HomeViewModel {
    
    let delegate = MulticastDelegate<HomeViewModelDelegate>()
    
    func setupATMCard() {
        delegate.notify {$0.homeViewModel(self)}
    }
}
