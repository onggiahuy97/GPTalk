//
//  UserViewModel.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/10/23.
//

import Foundation
import RevenueCat

class UserViewModel: ObservableObject {
    @Published var offerings: Offerings? = nil
    #warning("Beta testing")
    @Published var subscriptionActive: Bool = false
    @Published var customerInfo: CustomerInfo? {
        didSet {
            subscriptionActive = customerInfo?.entitlements[Constants.entitlementID]?.isActive == true
        }
    }
    
    init() {
        Purchases.shared.getCustomerInfo { customerInfo, _ in
            self.subscriptionActive = customerInfo?.entitlements[Constants.entitlementID]?.isActive == true
        }
    }
    
}
