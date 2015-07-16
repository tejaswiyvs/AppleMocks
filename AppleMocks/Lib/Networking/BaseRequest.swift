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
    
    typealias SuccessBlock = (AnyObject?) -> (Void)
    typealias FailureBlock = (Int) -> (Void)
    
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
        var urlRequest = NSMutableURLRequest(URL: url())
        self.addHeaders(self.headers(), request: urlRequest)
        urlRequest.HTTPBody = self.body()?.dataUsingEncoding(NSUTF8StringEncoding)
        var operation = AFHTTPRequestOperation(request: urlRequest)
        operation.setCompletionBlockWithSuccess({ [unowned self] (operation, responseData) -> Void in
            self.parseResponse(responseData as? NSData)
        }, failure: { (op, error) -> Void in
            self.messageFailure(error.code)
        })
        operation.start()
    }
    
    func parseResponse(var response:NSData?) {
        if let s = self.successBlock {
            s(response)
        }
    }
    
    func messageFailure(var code: Int) {
        if let f = self.failureBlock {
            f(code)
        }
    }
    
    func addHeaders(headers: Dictionary<String, String>, request: NSMutableURLRequest) {
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    func url() -> NSURL {
        return (relativeUrl() != nil) ? self.absoluteUrl(relativeUrl()!) : baseUrl!
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