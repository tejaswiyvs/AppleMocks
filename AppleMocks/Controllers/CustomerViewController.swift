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
    var addRequest: AddCustomerRequest?
    var updateRequest: UpdateCustomerRequest?
    
    @IBOutlet var customerNameTxtField: TextFieldValidator?
    @IBOutlet var saveBtn: UIButton?
    
    init(customer: Customer?) {
        self.customer = customer
        super.init(nibName: "CustomerView", bundle: NSBundle.mainBundle())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customerNameTxtField?.text = self.customer?.contactName
        self.setupTextFieldValidation()
    }
    
    @IBAction func saveBtnClicked(sender: UIButton) {
        if (self.customerNameTxtField?.text == nil || self.customerNameTxtField!.text!.isEmpty) {
            self.customerNameTxtField?.validate()
            self.customerNameTxtField?.becomeFirstResponder()
            return
        }
        
        if self.customer == nil {
            self.customer = Customer()
            self.customer?.contactName = self.customerNameTxtField?.text
            self.addCustomer(self.customer!)
        }
        else {
            self.customer?.contactName = self.customerNameTxtField?.text
        }
    }
    
    func addCustomer(let customer: Customer) {
        SVProgressHUD.showWithStatus("Saving...");
        self.addRequest = AddCustomerRequest(customer: customer, success: { [unowned self](result) -> (Void) in
                SVProgressHUD.showSuccessWithStatus("Completed")
                self.navigationController?.popViewControllerAnimated(true)
            },
            failure: { (resultCode) -> (Void) in
                SVProgressHUD.showErrorWithStatus("There was a problem saving your record. Please try again")
            }
        )
        self.addRequest?.start()
    }
    
    func updateCustomer(let customer: Customer) {
        SVProgressHUD.showWithStatus("Updating...")
        self.updateRequest = UpdateCustomerRequest(customer: customer, success: { [unowned self](result) -> (Void) in
                SVProgressHUD.showSuccessWithStatus("Updated!")
                self.navigationController?.popViewControllerAnimated(true)
            },
            failure: { (errorCode) -> (Void) in
                SVProgressHUD.showErrorWithStatus("There was a problem updating your record. Please try again")
            }
        )
        self.updateRequest?.start()
    }
    
    func setupTextFieldValidation() {
        self.customerNameTxtField?.isMandatory = true
        self.customerNameTxtField?.updateLengthValidationMsg("Customer name cannot be empty")
        self.customerNameTxtField?.presentInView = self.view
    }
}
