//
//  BaseService.swift
//  AppleMocks
//
//  Created by Tejaswi Yerukalapudi on 7/15/15.
//  Copyright (c) 2015 Tejaswi Yerukalapudi. All rights reserved.
//

import Foundation

class BaseRequest {
    let baseUrl = NSURL(string: "http://1860-6169.el-alt.com/odata")
    
    typealias SuccessBlock = ([AnyObject]?) -> (Void)
    typealias FailureBlock = (Int, String) -> (Void)
    
    var successBlock: SuccessBlock?
    var failureBlock: FailureBlock?
    
    init(success: SuccessBlock?, failure: FailureBlock?) {
        self.successBlock = success;
        self.failureBlock = failure;
    }
    
    func absoluteUrl(relativeUrl: String) -> NSURL {
        return baseUrl!.URLByAppendingPathComponent(relativeUrl)
    }
    
    func start() {
        var body = self.body()
        var headers = self.headers()
        var url = (relativeUrl() != nil) ? self.absoluteUrl(relativeUrl()!) : baseUrl!;
    }
    
    func relativeUrl() -> String? {
        return nil;
    }
    
    func body() -> String? {
        return nil;
    }
    
    func headers() -> Dictionary<String, String> {
        var headers = Dictionary<String, String>()
        headers["Content-Type"] = "application/json";
        headers["Accept"] = "application/json";
        // Optionally add authorization tokens, request nonces etc.
        return headers;
    }
    
    func method() -> String {
        return "GET";
    }
}