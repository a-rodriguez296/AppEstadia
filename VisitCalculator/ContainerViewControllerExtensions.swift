//
//  ContainerViewControllerExtensions.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 10/5/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation
import Bond

//MARK: Bond Setp
extension ContainerViewController{
    
    func bondSetup(){
        segmentedControl.bnd_selectedSegmentIndex.observe {[unowned self] (index) in
            
            //Handle add/remove child controller
            
            
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
            
            /*
             Show/hide add stay button
             If selected segment == 0, show it otherwise, don't
             */
            if index != 0 {
                self.navigationItem.setRightBarButtonItem(nil, animated: true)
            }
            else{
                //Bar button
                self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(self.didTapAddStay(_:))), animated: true)
            }
        }
        
        segmentedControl.bnd_selectedSegmentIndex.observe {[unowned self] (index) in
            
            //Change view's title depending on selected segment
            switch index{
            case 0:
                self.title = NSLocalizedString("Dates", comment: "")
            case 1:
                self.title = NSLocalizedString("Planning", comment: "")
            default:
                self.title = NSLocalizedString("Years", comment: "")
            }
        }
    }
}

//MARK: Autolayout
extension ContainerViewController{
    
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
        
        //If there are no stays, then disable planning and years section
        let staysCountFlag = CDStay.staysForTaxPayer(taxPayer!) != 0
        segmentedControl.setEnabled(staysCountFlag, forSegmentAtIndex: 1)
        segmentedControl.setEnabled(staysCountFlag, forSegmentAtIndex: 2)
    }
}

//MARK: ContainerVC Action handler
extension ContainerViewController{
    
    
    func initializeViewControllerWithIndex(index: Int) -> UIViewController{
        if index == 0{
            let vc = StaysListViewController()
            vc.viewModel = StaysListViewModel(taxPayer: taxPayer!)
            return vc
            
        }
        else if index == 1 {
            let vc = ChooseDynamicDateController()
            vc.viewModel = ChooseDynamicDateViewModel(taxPayer: taxPayer!)
            return vc
        }
        else{
            let vc = YearResultsViewController()
            vc.viewModel = YearResultsViewModel(payer: taxPayer!)
            return vc
        }
    }
    
    func removeViewController(viewController: UIViewController){
        viewController.willMoveToParentViewController(nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
}