//
//  NewSeasonTableViewController.swift
//  SportsCalendarPlanner
//
//  Created by Tomas Van Roose on 04/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

import UIKit
import Foundation

class NewSeasonTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    private var startDate : NSDate?
    private var endDate : NSDate?
    private var name : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startDate = NSDate()
        self.endDate = NSDate(timeInterval: 60*60*24*355, sinceDate: self.startDate!)
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell
        
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("seasonName")!
            cell.textLabel!.text! = "Name"
            cell.detailTextLabel!.text! = "Ongetiteld Seizoen"
        } else {
            
            let formatter = NSDateFormatter()
            let locale = NSLocale(localeIdentifier: "nl_BE")
            formatter.dateStyle = .MediumStyle
            formatter.locale = locale
            
            cell = tableView.dequeueReusableCellWithIdentifier("seasonDate")!
            
            if indexPath.row == 0 {
                cell.textLabel!.text! = "Start"
                if let date = self.startDate {
                    cell.detailTextLabel!.text! = formatter.stringFromDate(date)
                }
            } else if indexPath.row == 1 {
                cell.textLabel!.text! = "End"
                if let date = self.endDate {
                    cell.detailTextLabel!.text! = formatter.stringFromDate(date)
                }
            }
        }
        
        return cell
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func save(sender: UIBarButtonItem) {
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
