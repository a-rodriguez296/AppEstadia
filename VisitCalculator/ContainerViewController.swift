//
//  ContainerViewController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/23/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import Bond


class ContainerViewController: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    
    var taxPayer:CDTaxPayer?
    
    
    var currentChildVC:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        lblName.text = taxPayer?.name
        lblId.text = taxPayer?.id
        
        
        
        segmentedControl.bnd_selectedSegmentIndex.observe {[unowned self] (index) in
            
            //Remove current view controller
            if let child = self.currentChildVC{
                self.removeViewController(child)
            }
            
            let vcToAdd = self.initializeViewControllerWithIndex(index)
            
            self.addChildViewController(vcToAdd)
            self.containerView.addSubview(vcToAdd.view)
            vcToAdd.didMoveToParentViewController(self)
            
            self.anchorViewControllerToContainerView(vcToAdd)
            self.currentChildVC = vcToAdd
            
        }
        
        segmentedControl.bnd_selectedSegmentIndex.observe {[unowned self] (index) in
            if index != 0 {
                self.navigationItem.setRightBarButtonItem(nil, animated: true)
            }
            else{
                //Bar button
                self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(self.didTapAddStay(_:))), animated: true)
            }
        }
        
        segmentedControl.bnd_selectedSegmentIndex.observe {[unowned self] (index) in
            
            if index == 0{
               self.title = NSLocalizedString("Dates", comment: "")
            }
            else if index == 1{
                self.title = NSLocalizedString("Planning", comment: "")
            }
            else{
                self.title = NSLocalizedString("Years", comment: "")
            }
            
        }
        
        
        
        //NSNotifications
        signUpToNotifications()
        updateToolBarItemsState()
        
        
        
        
    }
    
    func didTapAddStay(sender: AnyObject) {
        
        let addStayVC = AddStayViewController()
        addStayVC.taxPayer = taxPayer
        navigationController?.pushViewController(addStayVC, animated: true)
        
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    //MARK: Helper Functions
    func removeViewController(viewController: UIViewController){
        viewController.willMoveToParentViewController(nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    func initializeViewControllerWithIndex(index: Int) -> UIViewController{
        if index == 0{
            let vc = StaysListViewController()
            vc.taxPayer = taxPayer!
            return vc
            
        }
        else if index == 1 {
            let vc = ChooseDynamicDateController()//storyboard.instantiateViewControllerWithIdentifier("ChooseCurrentDateController") as! ChooseCurrentDateController
            vc.taxPayer = taxPayer!
            return vc
        }
        else{
            let vc = YearResultsViewController()
            vc.taxPayer = taxPayer!
            return vc
        }
    }
    
    func anchorViewControllerToContainerView(viewController:UIViewController){
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor).active = true
        viewController.view.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor).active = true
        viewController.view.topAnchor.constraintEqualToAnchor(containerView.topAnchor).active = true
        viewController.view.bottomAnchor.constraintEqualToAnchor(containerView.bottomAnchor).active = true
    }
    
}


//MARK: NSNotifications
extension ContainerViewController{
    
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

