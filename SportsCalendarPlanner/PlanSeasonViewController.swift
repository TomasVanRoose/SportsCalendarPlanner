//
//  PlanSeasonViewController.swift
//  SportsCalendarPlanner
//
//  Created by Tomas Van Roose on 04/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

import UIKit
import CoreData

class PlanSeasonViewController: UITableViewController {

    var season : SeasonMO?
    var managedObjectContext : NSManagedObjectContext?
    var datePickerView : SeasonViewPicker?
    
    //var population : Population?
    
    var otherTeams : [String]?
    var homeGameDates : [NSDate]?
    var team : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Planner
        var teamManagedObjects = [TeamMO]()
        
        var teams = [String]()
        var datesForTeam = [[Int]]()
        var numberOfDatesForTeam = [Int]()
        
        let teamRequest = NSFetchRequest(entityName: "Team")
        teamRequest.predicate = NSPredicate(format: "season == %@", self.season!)
        teamRequest.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            teamManagedObjects = try self.managedObjectContext!.executeFetchRequest(teamRequest) as! [TeamMO]
            
            for teamMO in teamManagedObjects {
                
                let dateRequest = NSFetchRequest(entityName: "PlayableDate")
                dateRequest.predicate = NSPredicate(format: "team == %@", teamMO)
                let dateManagedObjects = try self.managedObjectContext!.executeFetchRequest(dateRequest) as! [PlayableDateMO]
                
                teams.append(teamMO.name!)
                
                var dates = [Int]()
                
                for dateObject in dateManagedObjects {
                    let dateNumber = season!.startDate?.daysBetween(dateObject.date!)
                    dates.append(dateNumber!)
                }
                
                datesForTeam.append(dates)
                numberOfDatesForTeam.append(dates.count)
            }
        } catch {
            fatalError("Could not fetch team or dates: \(error)")
        }
    
        
        
        /* Create C style arrays to pass to C Library */
        let pointerToDatesForTeam = UnsafeMutablePointer<UnsafeMutablePointer<Int32>>.alloc(teams.count)
        let pointerToNumberOfDatesForTeam = UnsafeMutablePointer<Int32>.alloc(teams.count)
        
        for i in 0..<teams.count {
            
            let datesCount = numberOfDatesForTeam[i]

            let pointerToDates = UnsafeMutablePointer<Int32>.alloc(datesCount)
            for j in 0..<datesCount {
                pointerToDates[j] = Int32(datesForTeam[i][j])
            }
            
            pointerToDatesForTeam[i] = pointerToDates
            pointerToNumberOfDatesForTeam[i] = Int32(datesCount)
        }
        
        plan_calendar(pointerToDatesForTeam, pointerToNumberOfDatesForTeam, Int32(teams.count), 30, 5)
        
        
        
        
    }
    
    func selectTeam(team : String) {
     /*
        if let pop = self.population {
            let teams = Population.teams
            self.otherTeams = teams!.filter { $0 != team }
            self.homeGameDates = pop.getHomeGameDatesForTeam(team)
            self.team = team
            self.tableView.reloadData()
        }
 */
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.team != nil {
            return otherTeams!.count
        } else  {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return otherTeams?[section]
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let date = self.homeGameDates![indexPath.section]

        if indexPath.row == 0 {
            cell = self.tableView.dequeueReusableCellWithIdentifier("gameDate")!
            cell.textLabel!.text = "Gamedate: \(formatter.stringFromDate(date))"
        } else {
            cell = self.tableView.dequeueReusableCellWithIdentifier("returnDate")!
            let returnDate = self.population!.returnGameFor(self.team!, game: date)
            
            
            let daysBetween = abs(date.daysBetween(returnDate))
            
            cell.textLabel!.text = "Returngame: \(formatter.stringFromDate(returnDate))"
            cell.detailTextLabel!.text = "\(daysBetween) days between"
        }
        
        
        return cell
    }
    
    
    */
    
}
