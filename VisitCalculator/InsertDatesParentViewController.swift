//
//  InsertDatesParentViewController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/23/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import Bond


class InsertDatesParentViewController: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    
    var taxPayer:CDTaxPayer?
    
    
    var insertDatesVC:InsertDatesController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        lblName.text = taxPayer?.name
        lblId.text = taxPayer?.id
        
        
        
        segmentedControl.bnd_selectedSegmentIndex.observe { (index) in
            print(index)
        }
        
        //Agregar lista estadias
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        insertDatesVC = storyboard.instantiateViewControllerWithIdentifier("InsertDatesController") as? InsertDatesController
        insertDatesVC?.taxPayer = taxPayer
        addChildViewController(insertDatesVC!)
        containerView.addSubview(insertDatesVC!.view)
        insertDatesVC?.didMoveToParentViewController(self)
        
        anchorViewControllerToContainerView(insertDatesVC!)
        
        
        //NSNotifications
        signUpToNotifications()
        updateToolBarItemsState()
    }
    
    
    func anchorViewControllerToContainerView(viewController:UIViewController){
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor).active = true
        viewController.view.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor).active = true
        viewController.view.topAnchor.constraintEqualToAnchor(containerView.topAnchor).active = true
        viewController.view.bottomAnchor.constraintEqualToAnchor(containerView.bottomAnchor).active = true
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.Segues.insertDatesSegue{
            let addDateVC = segue.destinationViewController as? AddDateViewController
            addDateVC?.taxPayer = taxPayer
        }
    }
    
    
    deinit{
         NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}


//MARK: NSNotifications
extension InsertDatesParentViewController{
    
    func signUpToNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateToolBarItemsState), name: Constants.NSNotifications.staysChanged, object: nil)
    }
    
    func updateToolBarItemsState(){
        
        //Parte CoreData
        let staysCountFlag = CDStay.staysForTaxPayer(taxPayer!) != 0
        segmentedControl.setEnabled(staysCountFlag, forSegmentAtIndex: 1)
        segmentedControl.setEnabled(staysCountFlag, forSegmentAtIndex: 2)
    }
}

