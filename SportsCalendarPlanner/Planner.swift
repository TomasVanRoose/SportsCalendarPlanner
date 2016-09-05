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
        print(teamsWithDates)
    }
    
    
    func planCalendar() -> ([NSDate]) {
        
        Population.initializeTeams(self.teamsWithDates, preferedDaysBetweenReturnGames: 30, preferedDaysBetweenConsecutieGames: 5)
        
        var populations = [Population]()
        
        for _ in 0..<populationSize {
            populations.append(Population.generateRandomPopulation())
        }
        
        return findFittestPopulation(populations).gameDates!
        
    }
    
    func findFittestPopulation(populations : [Population]) -> (Population) {
        
        var largest = Population()
        var largestFit = 0.0
        
        for pop in populations {
            let fit = pop.fitness()
            if fit > largestFit {
                largestFit = fit
                largest = pop
            }
        }
        return largest
    }
}
