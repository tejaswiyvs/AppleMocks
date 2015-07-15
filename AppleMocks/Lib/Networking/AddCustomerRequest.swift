//
//  CustomerService.swift
//  AppleMocks
//
//  Created by Tejaswi Yerukalapudi on 7/15/15.
//  Copyright (c) 2015 Tejaswi Yerukalapudi. All rights reserved.
//

import Foundation

class AddCustomerRequest : BaseRequest {
    override func relativeUrl() -> String? {
        return "Customers";
    }
    
    override func body() -> String? {
        return nil;
    }
    
    override func method() -> String {
        return "POST";
    }
}

class DeleteCustomerRequest : BaseRequest {
    override func relativeUrl() -> String? {
        return "Customers";
    }
    
    override func body() -> String? {
        return nil;
    }
    
    override func method() -> String {
        return "DELETE";
    }
}

class UpdateCustomerRequest : BaseRequest {
    override func relativeUrl() -> String? {
        return "Customers";
    }
    
    override func body() -> String? {
        return nil;
    }
    
    override func method() -> String {
        return "PATCH";
    }
}

class GetCustomersRequest : BaseRequest {
    override func relativeUrl() -> String? {
        return "Customers";
    }
    
    override func body() -> String? {
        return nil;
    }
        
    override func method() -> String {
        return "GET";
    }
}