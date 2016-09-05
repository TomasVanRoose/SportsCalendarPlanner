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
    var datePickerView : SeasonViewPicker?

    var homeDates : [String : [NSDate]]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Views
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        let frame = CGRect(x: 10, y: 40, width: self.view.frame.size.width, height: self.view.bounds.size.height)
        self.datePickerView = SeasonViewPicker.init(frame: frame, beginDate: self.season!.startDate!, endDate: self.season!.endDate!, dateFunc: nil)
        
        self.view.addSubview(self.datePickerView!)
        
        
        // Planner
        var teamManagedObjects = [TeamMO]()
        var teamsWithDates = [String : [NSDate]]()
        
        let teamRequest = NSFetchRequest(entityName: "Team")
        teamRequest.predicate = NSPredicate(format: "season == %@", self.season!)
        teamRequest.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            teamManagedObjects = try self.managedObjectContext!.executeFetchRequest(teamRequest) as! [TeamMO]
            
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
        
        let gameDates = planner.planCalendar()
        
        homeDates = [String : [NSDate]]()
        
        for i in 0..<teamManagedObjects.count {
            
            var dates = [NSDate]()
            for j in 0..<teamManagedObjects.count - 1 {
                dates.append(gameDates[i*(teamManagedObjects.count - 1) + j])
            }
            homeDates![teamManagedObjects[i].name!] = dates
        }
        
    }
    
    func selectTeam(team : String) {
        
        self.datePickerView?.deselectAllDatesInColor(UIColor.greenColor())
        
        let dates = homeDates![team]!
        
        for date in dates {
            self.datePickerView?.selectDate(date, color: UIColor.greenColor())
        }
        
    }

}
