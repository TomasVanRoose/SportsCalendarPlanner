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
        
        self.season = season
        
        let frame = CGRect(x: 10, y: 40, width: self.view.bounds.size.width, height: self.view.bounds.size.height);
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
                
            
            } else {
                picker.selectDate(date, color: UIColor.greenColor())
                _ = PlayableDateMO.createPlayableData(date, team: team, forContext: self.managedObjectContext!)
                
                do {
                    try self.managedObjectContext!.save()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
