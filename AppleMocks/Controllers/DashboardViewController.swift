//
//  DashboardViewController.swift
//  AppleMocks
//
//  Created by Tejaswi Yerukalapudi on 7/15/15.
//  Copyright (c) 2015 Tejaswi Yerukalapudi. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UIPopoverControllerDelegate {
    
    var popoverController: UIPopoverController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getPatientList(sender: UIButton) {
        let contentViewController = CustomerListViewController()
        let navigationBar = UINavigationController(rootViewController: contentViewController)
        self.popoverController = UIPopoverController(contentViewController: navigationBar)
        self.popoverController?.popoverContentSize = CGSizeMake(320.0, 480.0)
        [self.popoverController?.presentPopoverFromRect(sender.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)]
    }
 
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
        return true
    }
    
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController) {
    
    }
    
    func popoverController(popoverController: UIPopoverController, willRepositionPopoverToRect rect: UnsafeMutablePointer<CGRect>, inView view: AutoreleasingUnsafeMutablePointer<UIView?>) {
    
    }
}

