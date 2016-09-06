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
    
    
    func planCalendar() -> (Population) {
        
        Population.initializeTeams(self.teamsWithDates, preferedDaysBetweenReturnGames: 30, preferedDaysBetweenConsecutieGames: 5)
        
        var populations = [Population]()
        
        for _ in 0..<populationSize {
            populations.append(Population.generateRandomPopulation())
        }
        
        
        var popFitness = [Double]()
        for pop in populations {
            popFitness.append(pop.fitness())
        }
        
        var childGeneration = [Population]()
        var numberOfChildren = 0
        
        while numberOfChildren < populations.count {
            
            let mother = populations[tournamentSelection(2, populationFitnesses: popFitness)]
            let father = populations[tournamentSelection(2, populationFitnesses: popFitness)]
            
            let children = crossover(mother, father: father)
            
            //mutateChild
            
            childGeneration.append(children[0])
            childGeneration.append(children[1])
            
            numberOfChildren += 2
        }
        
        
        return findFittestPopulation(populations)
        
    }
    
    
    func crossover(mother : Population, father : Population) -> ([Population]) {
        
        // General idea: don't switch individual games because some home games would end up on the same date.
        //               crossover happens in slices, you either get all the hometeams for one team from mother or father
        // Two-point crossover
        
        let teamCount = Population.teams!.count
        
        //get a value in [1..teamcount - 1]
        let firstCrossOverPoint = Int(arc4random_uniform(UInt32(teamCount - 2)) + 1)
        let secondCrossOverPoint = Int(arc4random_uniform(UInt32(teamCount - (firstCrossOverPoint + 1)))) + (firstCrossOverPoint + 1)
        
        let firstRange = 0..<(firstCrossOverPoint * (teamCount - 1))
        let secondRange = firstCrossOverPoint * (teamCount - 1)..<(secondCrossOverPoint * (teamCount - 1))
        let thirdRange = secondCrossOverPoint * (teamCount - 1)..<Population.homeTeamArray!.count
        
        let firstChild = Population()
        firstChild.gameDates = Array(mother.gameDates![firstRange] + father.gameDates![secondRange] + mother.gameDates![thirdRange])
        
        let secondChild = Population()
        secondChild.gameDates = Array(father.gameDates![firstRange] + mother.gameDates![secondRange] + father.gameDates![thirdRange])
        
        return [firstChild, secondChild]
        
    }
    
    // Returns the index of a winner
    func tournamentSelection(k : Int, populationFitnesses : [Double]) -> (Int) {
        
        var indexOfBest = -1
        
        for _ in 0..<k {
            let randomIndex = Int(arc4random_uniform(UInt32(populationFitnesses.count)))
            
            if indexOfBest == -1 || populationFitnesses[randomIndex] > populationFitnesses[indexOfBest] {
                indexOfBest = randomIndex
            }
        }
        
        return indexOfBest
    }
    
    
    func findFittestPopulation(populations : [Population]) -> (Population) {
        
        var largest = Population()
        var largestFit = 0.0
        
        for pop in populations {
            let fit = pop.fitness()
            print(fit)
            if fit > largestFit {
                largestFit = fit
                largest = pop
            }
        }
        return largest
    }
}
