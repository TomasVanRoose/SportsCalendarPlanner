//
//  CalendarPresenterViewController.swift
//  SportsCalendarPlanner
//
//  Created by Tomas Van Roose on 04/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

import UIKit
import CoreData

class CalendarPresenterViewController: UIViewController {

    var season : SeasonMO?
    var team : TeamMO?
    var managedObjectContext : NSManagedObjectContext?
    
    var datePickerView : SeasonViewPicker?
    
    func selectSeason(season : SeasonMO) {
        
        if self.season != nil {
            for view in self.view.subviews {
                view.removeFromSuperview()
            }
        }
        
        self.season = season
        
        let frame = CGRect(x: 10, y: 40, width: self.view.frame.size.width, height: self.view.bounds.size.height);
        self.datePickerView = SeasonViewPicker.init(frame: frame, beginDate: season.startDate!, endDate: season.endDate!, dateFunc: didSelectDate)
        
        self.view.addSubview(self.datePickerView!)
        
    }
    
    func selectTeam(team : TeamMO) {
        
        self.team = team
        self.title = team.name
        
        if let datePicker = self.datePickerView {
            
            datePicker.deselectAllDatesInColor(UIColor.greenColor())
            
            let request = NSFetchRequest(entityName: "PlayableDate")
            request.predicate = NSPredicate(format: "team == %@", team)
            
            do {
                let playableDates = try self.managedObjectContext!.executeFetchRequest(request) as! [PlayableDateMO]
                
                for date in playableDates {
                    datePicker.selectDate(date.date!, color: UIColor.greenColor())
                }                
            } catch {
                fatalError("Failed to fetch playable dates: \(error)")
            }
        }
    }
    
    
    func didSelectDate(date : NSDate, color : UIColor, picker : SeasonViewPicker) {
        
        if let team = self.team {
            
            if color.isEqual(UIColor.greenColor()) {
                // Fetch the managedobject PlayableDate for that date and delete it
                let request = NSFetchRequest(entityName: "PlayableDate")
                request.predicate = NSPredicate(format: "team == %@", team)
                
                do {
                    let playableDates = try self.managedObjectContext!.executeFetchRequest(request) as! [PlayableDateMO]
                    for playableDate in playableDates {
                        if date.compareDays(playableDate.date!) == NSComparisonResult.OrderedSame {
                            self.managedObjectContext!.deleteObject(playableDate)
                            picker.selectDate(date, color: UIColor.blackColor())
                        }
                    }
                } catch {
                    fatalError("Failed to fetch playable dates :\(error)")
                }
            
            } else if color.isEqual(UIColor.blackColor()){
                // Save the selected date in the database
                picker.selectDate(date, color: UIColor.greenColor())
                _ = PlayableDateMO.createPlayableData(date, team: team, forContext: self.managedObjectContext!)
            }
            
            do {
                try self.managedObjectContext!.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let planViewController = segue.destinationViewController as? PlanSeasonViewController {
            planViewController.managedObjectContext = self.managedObjectContext
            planViewController.season = self.season
        }
    }
    

}
