//
//  CustomerViewController.swift
//  AppleMocks
//
//  Created by Tejaswi Yerukalapudi on 7/16/15.
//  Copyright (c) 2015 Tejaswi Yerukalapudi. All rights reserved.
//

import UIKit

class CustomerViewController: UIViewController {
    
    var customer: Customer?
    @IBOutlet var customerNameTxtField: UITextField?
    @IBOutlet var saveBtn: UIButton?
    
    init(customer: Customer?) {
        self.customer = customer
        super.init(nibName: "CustomerView", bundle: NSBundle.mainBundle())
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customerNameTxtField?.text = self.customer?.contactName
    }
    
    @IBAction func saveBtnClicked(sender: UIButton) {
        
    }
}
