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
        
        bondSetup()
        
        //NSNotifications setup
        signUpToNotifications()
        
        //Enable/disable sections if there are stays
        updateToolBarItemsState()
        
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: Actions
    func didTapAddStay(_ sender: AnyObject) {
        
        /*
         In this case, since the add stay button is only visible when StaysListViewController,
         I can be sure that currentChildVC is alwasy going to be StaysListViewController
         */
        let vc = currentChildVC as! StaysListViewController
        vc.stopTimer()
        
        let addStayVC = AddStayViewController()
        addStayVC.taxPayer = taxPayer
        addStayVC.viewModel = AddStayViewModel(taxPayer: taxPayer!)
        navigationController?.pushViewController(addStayVC, animated: true)
        
    }
}


