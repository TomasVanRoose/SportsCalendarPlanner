//
//  PlanSeasonViewController.swift
//  SportsCalendarPlanner
//
//  Created by Tomas Van Roose on 04/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

import UIKit
import CoreData

class PlanSeasonViewController: UIViewController {

    var season : SeasonMO?
    var managedObjectContext : NSManagedObjectContext?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var teamsWithDates = [String : [NSDate]]()
        
        let teamRequest = NSFetchRequest(entityName: "Team")
        teamRequest.predicate = NSPredicate(format: "season == %@", self.season!)
        
        do {
            let teamManagedObjects = try self.managedObjectContext!.executeFetchRequest(teamRequest) as! [TeamMO]
            
            for teamMO in teamManagedObjects {
                
                let dateRequest = NSFetchRequest(entityName: "PlayableDate")
                dateRequest.predicate = NSPredicate(format: "team == %@", teamMO)
                let dateManagedObjects = try self.managedObjectContext!.executeFetchRequest(dateRequest) as! [PlayableDateMO]
                
                var teamDates = [NSDate]()
                
                for dateObject in dateManagedObjects {
                    teamDates.append(dateObject.date!)
                }
                
                teamsWithDates[teamMO.name!] = teamDates
            }
        } catch {
            fatalError("Could not fetch team or dates: \(error)")
        }
        
        let planner = Planner(teamsWithDates: teamsWithDates)
        
        planner.planCalendar()
        
    }

}
