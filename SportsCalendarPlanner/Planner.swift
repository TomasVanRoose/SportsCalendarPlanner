//
//  Planner.swift
//  SportsCalendarPlanner
//
//  Created by Tomas Van Roose on 04/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

import Foundation

class Planner {
    
    let populationSize = 100
    
    private var teamsWithDates : [String : [NSDate]]
    
    init(teamsWithDates : [String : [NSDate]]) {
        
        self.teamsWithDates = teamsWithDates
    }
    
    
    func planCalendar() {
        
        Population.initializeTeams(self.teamsWithDates)
        
        var populations = [Population]()
        
        for i in 0..<populationSize {
            
            populations.append(Population.generateRandomPopulation())
        }
        
    }
}
