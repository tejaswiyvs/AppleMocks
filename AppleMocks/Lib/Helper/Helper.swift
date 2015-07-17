//
//  Helper.swift
//  AppleMocks
//
//  Created by Tejaswi Yerukalapudi on 7/17/15.
//  Copyright © 2015 Tejaswi Yerukalapudi. All rights reserved.
//

import Foundation

class Helper {
    static func presentAlert(message: String) {
        let alertView = UIAlertView(title: "Attention", message: message, delegate: nil, cancelButtonTitle: "Ok")
        alertView.show()
    }
}