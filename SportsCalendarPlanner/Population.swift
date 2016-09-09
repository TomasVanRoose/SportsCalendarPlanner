//
//  Population.swift
//  SportsCalendarPlanner
//
//  Created by Tomas Van Roose on 09/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

import Foundation
import CoreData

class Population {
    
    var teams : [String]
    
    var games : [Game]
    
    init(daysBetweenConsecutiveGames : Int, daysBetweenReturnGames : Int, season : SeasonMO, managedObjectContext : NSManagedObjectContext) {
        
        teams = [String]()
        var teamManagedObjects = [TeamMO]()
        
        
        var datesForTeam = [[Int]]()
        var numberOfDatesForTeam = [Int]()
        
        let teamRequest = NSFetchRequest(entityName: "Team")
        teamRequest.predicate = NSPredicate(format: "season == %@", season)
        teamRequest.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            teamManagedObjects = try managedObjectContext.executeFetchRequest(teamRequest) as! [TeamMO]
            
            for teamMO in teamManagedObjects {
                
                let dateRequest = NSFetchRequest(entityName: "PlayableDate")
                dateRequest.predicate = NSPredicate(format: "team == %@", teamMO)
                let dateManagedObjects = try managedObjectContext.executeFetchRequest(dateRequest) as! [PlayableDateMO]
                
                teams.append(teamMO.name!)
                
                var dates = [Int]()
                
                for dateObject in dateManagedObjects {
                    let dateNumber = season.startDate?.daysBetween(dateObject.date!)
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
        
        let solution : UnsafeMutablePointer<Int32> = plan_calendar(pointerToDatesForTeam, pointerToNumberOfDatesForTeam, Int32(teams.count), 15, 5)
     
        self.games = [Game]()
        let dayComponent = NSDateComponents()
        let calendar = NSCalendar.currentCalendar()
        
        for i in 0..<(teams.count - 1)*teams.count {
            
            let homeTeam = teams[i / (teams.count - 1)]
           
            var awayTeam = ""
            if (i % (teams.count - 1) < i / (teams.count - 1)) {
                awayTeam = teams[(i % (teams.count - 1))]
            } else {
                awayTeam = teams[(i % (teams.count - 1)) + 1]
            }
            
            dayComponent.day = Int(solution[i]) + 1
            let date = calendar.dateByAddingComponents(dayComponent, toDate: season.startDate!, options: NSCalendarOptions(rawValue: UInt(0)))
        
            games.append(Game(homeTeam: homeTeam, awayTeam: awayTeam, date: date!))
        }
        
        solution.destroy()
        solution.dealloc((teams.count - 1) * teams.count)
        
        for i in 0..<teams.count {
            pointerToDatesForTeam[i].destroy()
            pointerToDatesForTeam[i].dealloc(numberOfDatesForTeam[i])
        }
        pointerToDatesForTeam.destroy()
        pointerToDatesForTeam.dealloc(teams.count)
        pointerToNumberOfDatesForTeam.destroy()
        pointerToNumberOfDatesForTeam.dealloc(teams.count)
        
    }
    
}
