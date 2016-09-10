//
//  PlannedCalendarPresenterViewController.swift
//  SportsCalendarPlanner
//
//  Created by Tomas Van Roose on 09/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

import UIKit

class PlannedCalendarPresenterViewController: UIViewController {

    var population : Population?
    
    var datePickerView : SeasonViewPicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func selectTeam(team : String) {
        
        if datePickerView == nil {
            
            let frame = CGRect(x: 10, y: 40, width: self.view.frame.size.width, height: self.view.frame.size.height);
            self.datePickerView = SeasonViewPicker(frame: frame, beginDate: population!.beginDate, endDate: population!.endDate, dateFunc: nil)
            
            self.view.addSubview(self.datePickerView!)
        }
        
        if let population = self.population {
            self.datePickerView!.deselectAllDatesInColor(UIColor.greenColor())
            self.datePickerView!.deselectAllDatesInColor(UIColor.redColor())
            
            let homeGames = population.getAllHomeGamesForTeam(team)
            
            for game in homeGames {
                self.datePickerView!.selectDate(game.date, color: UIColor.greenColor())
            }
            
            let awayGames = population.getAllAwayGamesForTeam(team)
            
            for game in awayGames {
                self.datePickerView!.selectDate(game.date, color: UIColor.redColor())
            }
        }
    }

}
