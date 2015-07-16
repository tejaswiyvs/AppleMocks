//
//  Customer.swift
//  AppleMocks
//
//  Created by Tejaswi Yerukalapudi on 7/15/15.
//  Copyright (c) 2015 Tejaswi Yerukalapudi. All rights reserved.
//

import UIKit

class Customer {
    var customerId: String?
    var companyName: String?
    var contactName: String?
    var contactTitle: String?
    var profilePictureName: String?
    
    init() {
        
    }
    
    init(json: JSON) {
        self.customerId = json["CustomerID"].stringValue
        self.companyName = json["CompanyName"].stringValue
        self.contactTitle = json["ContactTitle"].stringValue
        self.contactName = json["ContactName"].stringValue
    }
}
