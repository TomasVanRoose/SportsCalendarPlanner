//
//  SeasonsTableViewController.swift
//  SportsCalendarPlanner
//
//  Created by Tomas Van Roose on 03/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

import UIKit
import CoreData

class SeasonsTableViewController: CoreDataTableViewController {

    var managedObjectContext: NSManagedObjectContext?
    var detailViewController : CalendarPresenterViewController?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source
    
    override func configureCell(indexPath: NSIndexPath) -> (UITableViewCell) {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("season")!
        
        let season = self.fetchedResultsController.objectAtIndexPath(indexPath) as! SeasonMO
        
        cell.textLabel!.text! = season.name!
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if let destination = segue.destinationViewController as? UINavigationController {
            if let newSeasonController = destination.topViewController as? NewSeasonTableViewController {
                newSeasonController.didSaveFunc = seasonCreatorDidReturn
            }
        } else if let destination = segue.destinationViewController as? TeamsViewController {
            
            let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)!
            let season = self.fetchedResultsController.objectAtIndexPath(indexPath) as! SeasonMO
            
            destination.season = season
            destination.managedObjectContext = self.managedObjectContext
            destination.detailViewController = self.detailViewController

            if let detail = self.detailViewController {
                detail.selectSeason(season)
            }
        }

    }
    
    
    // MARK: - Core Data
    
    func seasonCreatorDidReturn(name : String, startDate :  NSDate, endDate : NSDate) {
        
        _ = SeasonMO.createNewSeason(name, startDate: startDate, endDate: endDate, forContext: self.managedObjectContext!)
        
        do {
            try self.managedObjectContext!.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
    }
    
    override func initializeFetchedResultsController() {
        let request = NSFetchRequest(entityName: "Season")
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [ nameSort ]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }

}
