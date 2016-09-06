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
    
    static var homeTeamArray : [String]?
    static var awayArray : [String]?
    
    static var teamDates : [[NSDate]]?
    static var teams : [String]?
    
    static var preferedDaysBetweenReturnGames = 0
    static var preferedDaysBetweenConsecutieGames = 0
    
    class func initializeTeams(teamsWithDates : [String : [NSDate]], preferedDaysBetweenReturnGames : Int, preferedDaysBetweenConsecutieGames : Int) {
        
        self.preferedDaysBetweenReturnGames = preferedDaysBetweenReturnGames
        self.preferedDaysBetweenConsecutieGames = preferedDaysBetweenConsecutieGames
        
        self.teams = ([String](teamsWithDates.keys)).sort()
        
        self.homeTeamArray = [String]()
        self.awayArray = [String]()
        self.teamDates = [[NSDate]]()
        
        for team in self.teams! {
            
            teamDates!.append(teamsWithDates[team]!)
            
            for _ in 1...teams!.count - 1 {
                homeTeamArray!.append(team)
            }
            for outTeam in self.teams! {
                if outTeam != team {
                    awayArray!.append(outTeam)
                }
            }
        }
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
        
        return population
    }
    
    // Instance variables
    var gameDates : [NSDate]?
    
    
    func fitness() -> Double {
        
        var consecutiveFitness = 0.0
        let teamCount = Population.teams!.count
        let preferedCons = Population.preferedDaysBetweenConsecutieGames
        // The more days between two consecutive games the better the fitness score
        for i in 0..<teamCount - 1 {
            
            let date = self.gameDates![i]
            
            var leastDaysBetween = Int.max

            for j in 1..<teamCount {
                let otherDate = self.gameDates![j*(teamCount-1)]
                let daysBetween = abs(date.daysBetween(otherDate))
                
                if  daysBetween < leastDaysBetween {
                    leastDaysBetween = daysBetween
                }
            }
            
            if leastDaysBetween < preferedCons {
                consecutiveFitness += Double(leastDaysBetween)/Double(preferedCons)
            } else {
                consecutiveFitness += 0.8 + ((0.2 * Double(leastDaysBetween))/Double(preferedCons))
            }
        }
        
        consecutiveFitness = consecutiveFitness / Double(teamCount - 1)
        
        // The more days between home and away game the better
        var i = 0
        var j = 0
        var returnFitness = 0.0
        let prefered = Double(Population.preferedDaysBetweenReturnGames)
        let firstSlope = 0.8 * prefered

        while i < Population.homeTeamArray!.count {
            
            let homeDate = self.gameDates![i]
            let awayDate = self.gameDates![j*(teamCount - 2) + (teamCount - 1)]
            
            let daysBetween = Double(abs(homeDate.daysBetween(awayDate)))

            if (daysBetween <= firstSlope) {
                returnFitness += (0.2 * daysBetween)/firstSlope
            } else if (daysBetween <= prefered) {
                returnFitness += ((0.8 * daysBetween)/(prefered - firstSlope)) - ((0.8*firstSlope)/(prefered - firstSlope)) + 0.2
            } else {
                returnFitness += 0.8 + (0.2 * daysBetween)/prefered
            }
            
            i += 1
            j += 1
            if i % (teamCount - 1) == 0 {
                i += (i/(teamCount - 1))
                j = 0
            }
            
        }
        
        let numberOfGames = Double(teamCount*(teamCount - 1))/2.0
        
        returnFitness = returnFitness/numberOfGames
        
        return consecutiveFitness + returnFitness
    }
    
    func getHomeGameDatesForTeam(team : String) -> [NSDate] {
        
        var homeGames = [NSDate]()
        
        let teamIndex = Population.teams!.indexOf(team)!
        let numberOfTeams = Population.teams!.count
        
        let from = teamIndex * (numberOfTeams - 1)
        let to = (teamIndex + 1) * (numberOfTeams - 1)
        
        for i in from..<to {
            homeGames.append(self.gameDates![i])
        }
        
        return homeGames
    }
    
    func returnGameFor(team : String, game : NSDate) -> NSDate {
        
        var index = 0
        
        for i in 0..<self.gameDates!.count {
            if Population.homeTeamArray![i] == team && self.gameDates![i] == game {
                index = i
                break
            }
        }
        
        let awayTeam = Population.awayArray![index]
        let awayTeamIndex = Population.teams!.indexOf(awayTeam)!
        
        let teamsWithoutAwayTeam = Population.teams!.filter { $0 != awayTeam }
        let homeTeamIndex = teamsWithoutAwayTeam.indexOf(team)!
        
        
        return self.gameDates![(awayTeamIndex * (Population.teams!.count - 1)) + homeTeamIndex]
        
    }
    
    
    
    
}
