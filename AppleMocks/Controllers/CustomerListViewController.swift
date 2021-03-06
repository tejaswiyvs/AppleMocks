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
    var currentPageNumer: Int?
    let defaultPageSize = 20
    
    init() {
        super.init(style: UITableViewStyle.Plain)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addButtonClicked:"))
        self.title = "Customers"
        self.tableView.contentInset = UIEdgeInsetsZero
        self.tableView.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRectMake(0.0, 0.0, 24.0, 24.0))
        self.tableView.addInfiniteScrollWithHandler { [unowned self](tableView) -> Void in
            self.currentPageNumer!++
            self.fetchCurrentPage(nil)
            self.tableView.finishInfiniteScroll()
        }
        self.configurePullToRefresh()
        self.currentPageNumer = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchCurrentPage(nil)
    }
        
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
            self.deleteCustomersRequest = DeleteCustomerRequest(customer: customer, success: { (result) -> (Void) in
                tableView.reloadData()
            }, failure: { [unowned self] (errorCode) -> (Void) in
                self.customerList?.insert(customer, atIndex: indexPath.row)
                tableView.reloadData()
            })
            self.deleteCustomersRequest?.start()
        }
    }
    
    /* Event Handlers */
    func addButtonClicked(sender: UIButton) {
        self.pushCustomerInfoScreen(nil)
    }
    
    /* Helpers */
    func triggerRefreshControl() {
        self.refreshControl?.beginRefreshing()
        if self.tableView.contentOffset.y == 0 {
            UIView.animateWithDuration(0.25,
                delay: 0,
                options:UIViewAnimationOptions.BeginFromCurrentState,
                animations: { [unowned self]() -> Void in
                    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl!.frame.size.height);
                },
                completion:nil)
        }
    }
    
    func dismissRefreshControl() {
        self.refreshControl?.endRefreshing()
    }
    
    func configurePullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: Selector("fetchCurrentPage:"), forControlEvents: UIControlEvents.ValueChanged)
    }
        
    func pushCustomerInfoScreen(customer: Customer?) {
        let customerInfo = CustomerViewController(customer: customer)
        self.navigationController?.pushViewController(customerInfo, animated: true)
    }
    
    func fetchCurrentPage(sender: AnyObject?) {
        let success: BaseRequest.SuccessBlock = { [unowned self] (result: AnyObject?) -> (Void) in
            if let r:AnyObject = result {
                let customerList: [Customer]? = r as? [Customer]
                if self.customerList == nil {
                    self.customerList = [Customer]()
                }
                if let c = customerList {
                    self.customerList! += c
                }
            }
            self.tableView.reloadData()
            self.dismissRefreshControl()
        }
        
        let failure: BaseRequest.FailureBlock = { (Int) -> (Void) in
            self.refreshControl?.endRefreshing()
            self.dismissRefreshControl()
        }
        self.triggerRefreshControl()
        
        self.getCustomersRequest = GetCustomersRequest(pageNumber: self.currentPageNumer!, pageSize: self.defaultPageSize, success: success, failure: failure);
        self.getCustomersRequest!.start()
    }
    
}
