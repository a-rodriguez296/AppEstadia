//
//  CoreDataViewController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/6/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import MagicalRecord

class CoreDataViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    var stays:[CDStay]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        stays = CDStay.MR_findAll() as? [CDStay]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapAddStay(sender: AnyObject) {
        
        let name = DateFormatHelper.stringFromDate(NSDate())
        let _ = CDStay(name: name, context: NSManagedObjectContext.MR_defaultContext())
        saveContext()
    }
    
    func saveContext(){
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion { (flag, error) in
            if flag{
                self.stays = CDStay.MR_findAll() as? [CDStay]
                self.tableView.reloadData()
            }
        }
    }
}


extension CoreDataViewController:UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(stays.count)
        return stays.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .Subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = stays[indexPath.row].name
        return cell
    }
    
    
}
