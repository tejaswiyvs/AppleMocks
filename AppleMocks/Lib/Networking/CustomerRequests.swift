//
//  CustomerService.swift
//  AppleMocks
//
//  Created by Tejaswi Yerukalapudi on 7/15/15.
//  Copyright (c) 2015 Tejaswi Yerukalapudi. All rights reserved.
//

import Foundation

class AddCustomerRequest : BaseRequest {
    
    var customer: Customer
    
    init(customer: Customer, success: SuccessBlock?, failure: FailureBlock?) {
        self.customer = customer
        super.init(success: success, failure: failure);
    }
    
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
    
    var customer: Customer
    
    init(customer: Customer, success: SuccessBlock?, failure: FailureBlock?) {
        self.customer = customer
        super.init(success: success, failure: failure)
    }
    
    override func relativeUrl() -> String? {
        if self.customer.customerId == nil || self.customer.customerId!.isEmpty {
            return "Customers";
        }
        return "Customers('" + self.customer.customerId! + "')";
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
    
    override func parseResponse(responseData: NSData?) {
        if let d = responseData {
            let jsonObject: AnyObject! = NSJSONSerialization.JSONObjectWithData(d, options: nil, error: nil)
            var json = JSON(jsonObject)

            var customers: [Customer] = [Customer]()
            for (key, subJson) in json["value"] {
                let customer = Customer(json: subJson)
                customers.append(customer)
            }
            
            if let s = self.successBlock {
                s(customers)
            }
        }
        else {
            self.messageFailure(-1)
        }
    }
}