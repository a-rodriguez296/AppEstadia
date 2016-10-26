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
        segmentedControl.bnd_selectedSegmentIndex.observeNext {[unowned self] (index) in
            
            //Handle add/remove child controller
            
            
            //Remove current view controller
            if let child = self.currentChildVC{
                self.removeViewController(child)
            }
            
            let vcToAdd = self.initializeViewControllerWithIndex(index)
            
            self.addChildViewController(vcToAdd)
            self.containerView.addSubview(vcToAdd.view)
            vcToAdd.didMove(toParentViewController: self)
            
            self.anchorViewControllerToContainerView(vcToAdd)
            self.currentChildVC = vcToAdd
            
        }.dispose()
        
        segmentedControl.bnd_selectedSegmentIndex.observeNext {[unowned self] (index) in
            
            /*
             Show/hide add stay button
             If selected segment == 0, show it otherwise, don't
             */
            if index != 0 {
                self.navigationItem.setRightBarButton(nil, animated: true)
            }
            else{
                //Bar button
                self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.didTapAddStay(_:))), animated: true)
            }
        }.dispose()
        
        segmentedControl.bnd_selectedSegmentIndex.observeNext {[unowned self] (index) in
            
            //Change view's title depending on selected segment
            switch index{
            case 0:
                self.title = NSLocalizedString("Dates", comment: "")
            case 1:
                self.title = NSLocalizedString("Planning", comment: "")
            default:
                self.title = NSLocalizedString("Years", comment: "")
            }
        }.dispose()
    }
}

//MARK: Autolayout
extension ContainerViewController{
    
    func anchorViewControllerToContainerView(_ viewController:UIViewController){
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
}

//MARK: NSNotifications
extension ContainerViewController{
    
    func signUpToNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(updateToolBarItemsState), name: NSNotification.Name(rawValue: Constants.NSNotifications.staysChanged), object: nil)
    }
    
    func updateToolBarItemsState(){
        
        //If there are no stays, then disable planning and years section
        let staysCountFlag = CDStay.staysForTaxPayer(taxPayer!) != 0
        segmentedControl.setEnabled(staysCountFlag, forSegmentAt: 1)
        segmentedControl.setEnabled(staysCountFlag, forSegmentAt: 2)
    }
}

//MARK: ContainerVC Action handler
extension ContainerViewController{
    
    
    func initializeViewControllerWithIndex(_ index: Int) -> UIViewController{
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
    
    func removeViewController(_ viewController: UIViewController){
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
}
