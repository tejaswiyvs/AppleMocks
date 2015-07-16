//
//  CustomerListViewController.swift
//  AppleMocks
//
//  Created by Tejaswi Yerukalapudi on 7/16/15.
//  Copyright (c) 2015 Tejaswi Yerukalapudi. All rights reserved.
//

import UIKit

class CustomerListViewController: UITableViewController {
    
    let cellReuseId = "customerCell"
    
    var customerList: [Customer]?
    var spinner = SVProgressHUD()
    var getCustomersRequest: GetCustomersRequest?
    var deleteCustomersRequest: DeleteCustomerRequest?
    
    init() {
        super.init(style: UITableViewStyle.Grouped)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        self.fetchData()
        self.title = "Customers"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addButtonClicked:"))
    }
    
    /* UITableViewDelegate */
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let l = customerList {
            return l.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let customer = self.customerList![indexPath.row]
        self.pushCustomerInfoScreen(customer)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var tableViewCell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellReuseId) as UITableViewCell?
        if tableViewCell == nil {
            tableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellReuseId)
        }
        
        let model = self.customerList![indexPath.row]
        tableViewCell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        if let pictureName = model.profilePictureName {
            tableViewCell!.imageView?.image = UIImage(named: pictureName)
        }
        tableViewCell?.textLabel?.text = model.contactName
        
        return tableViewCell!
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let customer = self.customerList![indexPath.row]
            self.customerList?.removeAtIndex(indexPath.row)
            SVProgressHUD.showWithStatus("Deleting...")
            self.deleteCustomersRequest = DeleteCustomerRequest(customer: customer, success: { (result) -> (Void) in
                SVProgressHUD.dismiss()
            }, failure: { [unowned self] (errorCode) -> (Void) in
                self.customerList?.insert(customer, atIndex: indexPath.row)
                tableView.reloadData()
                SVProgressHUD.showErrorWithStatus("There was a problem deleting your record. Please try again")
            })
            self.deleteCustomersRequest?.start()
        }
    }
    
    /* Event Handlers */
    func addButtonClicked(sender: UIButton) {
        self.pushCustomerInfoScreen(nil)
    }
    
    /* Helpers */
    func pushCustomerInfoScreen(customer: Customer?) {
        let customerInfo = CustomerViewController(customer: customer)
        self.navigationController?.pushViewController(customerInfo, animated: true)
    }
    
    func fetchData() {
        SVProgressHUD.showWithStatus("Loading...")
        
        let success: BaseRequest.SuccessBlock = { [unowned self] (result: AnyObject?) -> (Void) in
            if let r:AnyObject = result {
                self.customerList = r as? [Customer]
            }
            SVProgressHUD.showSuccessWithStatus("Done")
            self.tableView.reloadData()
        }
        
        let failure: BaseRequest.FailureBlock = { (Int) -> (Void) in
            SVProgressHUD.showErrorWithStatus("There was a problem while fetching your data. Please try again.")
        }
        
        self.getCustomersRequest = GetCustomersRequest(success: success, failure: failure);
        self.getCustomersRequest!.start()
        self.tableView.reloadData()
    }
    
}
