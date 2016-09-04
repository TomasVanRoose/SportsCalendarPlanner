//
//  TeamsViewController.swift
//  SportsCalendarPlanner
//
//  Created by Tomas Van Roose on 04/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

import UIKit
import CoreData

class TeamsViewController: CoreDataTableViewController {

    var season : SeasonMO!
    var managedObjectContext: NSManagedObjectContext?
    var detailViewController : CalendarPresenterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = season.name
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let team = self.fetchedResultsController.objectAtIndexPath(indexPath) as! TeamMO
        
        if let detail = self.detailViewController {
            detail.selectTeam(team)
        }
    }

    override func initializeFetchedResultsController() {
        
        let request = NSFetchRequest(entityName: "Team")
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [ nameSort ]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
    }
    
    override func configureCell(indexPath: NSIndexPath) -> (UITableViewCell) {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("team")!
        
        let team = self.fetchedResultsController.objectAtIndexPath(indexPath) as! TeamMO
        
        cell.textLabel!.text! = team.name!
        
        return cell
    }
    
    func didInputTeamName(name : String) {
        _ = TeamMO.createNewTeam(name, season: self.season, forContext: self.managedObjectContext!)
        
        do {
            try self.managedObjectContext!.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if let destination = segue.destinationViewController as? UINavigationController {
            if let inputController = destination.topViewController as? InputTableViewController {
                inputController.didInputFunc = didInputTeamName
            }
        }
        
    }
    

}
