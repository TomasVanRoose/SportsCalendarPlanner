//
//  Population.swift
//  SportsCalendarPlanner
//
//  Created by Tomas Van Roose on 04/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

import Foundation

extension MutableCollectionType where Index == Int {
    mutating func shuffleInPlace() {
        if count < 2 {
            return
        }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else {
                continue
            }
            swap(&self[i], &self[j])
        }
    }
}

class Population {
    
    private static var homeTeamArray : [String]?
    private static var awayArray : [String]?
    
    private static var teamDates : [[NSDate]]?
    private static var teams : [String]?
    
    class func initializeTeams(teamsWithDates : [String : [NSDate]]) {
        
        self.teams = [String](teamsWithDates.keys)
        self.teamDates = [[NSDate]](teamsWithDates.values)
        
        homeTeamArray = [String]()
        awayArray = [String]()
        
        for team in self.teams! {
            for _ in 1...teams!.count - 1 {
                homeTeamArray!.append(team)
            }
            for outTeam in self.teams! {
                if outTeam != team {
                    awayArray!.append(outTeam)
                }
            }
        }
        print(homeTeamArray)
        print(awayArray)
    }
    
    class func generateRandomPopulation() -> (Population) {
        
        let population = Population()
        population.gameDates = [NSDate]()
        
        for i in 0..<self.teams!.count {
            
            var dates = self.teamDates![i]
            dates.shuffleInPlace()
            dates = Array(dates.prefix(self.teams!.count - 1))
            population.gameDates!.appendContentsOf(dates)
        }
        
        print(population.gameDates)
        return population
    }
    
    // Instance variables
    
    private var gameDates : [NSDate]?
    
    
    func fitness() -> int {
        
        
        
        return 0
    }
    
    
    
    
    
    
    
    
}
