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
    
    init() {
        super.init(style: UITableViewStyle.Grouped)
    }
    
    override init!(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder: NSCoder) {
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
        var customer = self.customerList![indexPath.row]
        self.pushCustomerInfoScreen(customer)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var tableViewCell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellReuseId) as? UITableViewCell
        if tableViewCell == nil {
            tableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellReuseId)
        }
        
        var model = self.customerList![indexPath.row]
        tableViewCell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        if let pictureName = model.profilePictureName {
            tableViewCell!.imageView?.image = UIImage(named: pictureName)
        }
        tableViewCell?.textLabel?.text = model.contactName
        
        return tableViewCell!
    }
    
    /* Event Handlers */
    func addButtonClicked(sender: UIButton) {
        self.pushCustomerInfoScreen(nil)
    }
    
    /* Helpers */
    func pushCustomerInfoScreen(customer: Customer?) {
        var customerInfo = CustomerViewController(customer: customer)
        self.navigationController?.pushViewController(customerInfo, animated: true)
    }
    
    func fetchData() {
        SVProgressHUD.showWithStatus("Loading...")
        
        var success: BaseRequest.SuccessBlock = { [unowned self] (result: AnyObject?) -> (Void) in
            if let r:AnyObject = result {
                self.customerList = r as? [Customer]
            }
            SVProgressHUD.showSuccessWithStatus("Done")
            self.tableView.reloadData()
        }
        
        var failure: BaseRequest.FailureBlock = { (Int) -> (Void) in
            SVProgressHUD.showErrorWithStatus("There was a problem while fetching your data. Please try again.")
        }
        
        self.getCustomersRequest = GetCustomersRequest(success: success, failure: failure);
        self.getCustomersRequest!.start()
        self.tableView.reloadData()
    }
    
}