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
    
    override func body() throws -> NSData? {
        let json: JSON = JSON(self.customer.toJSON())
        return try json.rawData()
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
    
    override func body() -> NSData? {
        return nil;
    }
    
    override func method() -> String {
        return "DELETE";
    }
}

class UpdateCustomerRequest : BaseRequest {
    
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
    
    override func body() throws -> NSData? {
        let json: JSON = JSON(self.customer.toJSON())
        return try json.rawData()
    }
    
    override func method() -> String {
        return "PATCH";
    }
}

class GetCustomersRequest : BaseRequest {
    var pageNumber: Int
    var pageSize: Int
    
    init(pageNumber: Int, pageSize: Int, success: SuccessBlock?, failure: FailureBlock?) {
        self.pageNumber = pageNumber
        self.pageSize = pageSize
        super.init(success: success, failure: failure)
    }
    
    override func relativeUrl() -> String? {
        let skip = String(pageNumber * pageSize)
        let pageSizeStr = String(pageSize)
        return "Customers?$top=" + pageSizeStr + "&$skip=" + skip;
    }
    
    override func body() -> NSData? {
        return nil;
    }
        
    override func method() -> String {
        return "GET";
    }
    
    override func parseResponse(responseData: NSData?) {
        if let d = responseData {
            let jsonObject: AnyObject!
            do {
                jsonObject = try NSJSONSerialization.JSONObjectWithData(d, options: [])
            } catch _ {
                jsonObject = nil
            }
            var json = JSON(jsonObject)

            var customers: [Customer] = [Customer]()
            for (_, subJson) in json["value"] {
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