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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source
    
    override func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        
        let season = fetchedResultsController.objectAtIndexPath(indexPath) as! SeasonMO
        
        cell.textLabel!.text! = season.name!;
        cell.detailTextLabel!.text! = "\(season.startDate!) - \(season.endDate!)"
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
    }
    
    
    // MARK: - Core Data
    
    override func initializeFetchedResultsController() {
        let request = NSFetchRequest(entityName: "Season")
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [ nameSort ]
        
        //let moc = self.dataController.managedObjectContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }

}
