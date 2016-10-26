//
//  YearResultsViewController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/1/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import SwiftDate
import MBProgressHUD

class YearResultsViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel:YearResultsViewModel?
    
    
    var responseArray:[YearResponse]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        
        //I dont understand why do I have to put this method inside a dispatch_async
        DispatchQueue.main.async {[unowned self] () in
            self.viewModel!.performCalculations()
        }
        
        
        viewModel!.shouldReloadTable = {[unowned self] () in
            self.tableView.reloadData()
        }
        
        viewModel!.performingCalculationsEvent.observeNext { (flag) in
            if flag{
                //Mostrarlo
                self.showProgressAlert()
            }
            else{
                //Quitarlo
                self.removeProgressAlert()
            }
        }.dispose()
    }
    
    func setupTable(){
        
        tableView.register(UINib(nibName: Constants.Cells.YearConclusion.yearConclusionCell,  bundle: nil), forCellReuseIdentifier: Constants.Cells.YearConclusion.yearConclusionCell)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 86
        tableView.tableFooterView = UIView()
    }
    
    
    func showProgressAlert(){
        let progressHud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        progressHud.mode = .indeterminate
        progressHud.label.text = NSLocalizedString("Performing Calculations", comment: "")
        
    }
    
    func removeProgressAlert(){
        MBProgressHUD.hide(for: UIApplication.shared.keyWindow!, animated: true)
    }
}

extension YearResultsViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.responseArray.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.YearConclusion.yearConclusionCell) as! YearsConclusionCell
        
        cell.initializeWithYearResponse(viewModel!.responseArray.value[indexPath.row])
        return cell
    }
}
