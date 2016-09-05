//
//  SportsCalendarPlannerTests.swift
//  SportsCalendarPlannerTests
//
//  Created by Tomas Van Roose on 03/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

import XCTest
import Foundation
@testable import SportsCalendarPlanner

class SportsCalendarPlannerTests: XCTestCase {
    
    
    
    override func setUp() {
        super.setUp()


        var tomas : [String] = ["2017-02-27 11:00:00", "2016-12-31 11:00:00", "2016-09-16 10:00:00", "2016-11-04 11:00:00"]
        var simon : [String] = ["2016-10-01 10:00:00", "2016-12-01 11:00:00", "2016-09-16 10:00:00", "2016-11-18 11:00:00"]
        var andrew : [String] = ["2016-09-02 10:00:00", "2016-11-02 11:00:00", "2016-10-13 10:00:00", "2016-12-15 11:00:00"]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        var tomasDates = [NSDate]()
        var andrewDates = [NSDate]()
        var simonDates = [NSDate]()
        
        for i in 0..<tomas.count {
            tomasDates.append(dateFormatter.dateFromString(tomas[i])!)
            simonDates.append(dateFormatter.dateFromString(simon[i])!)
            andrewDates.append(dateFormatter.dateFromString(andrew[i])!)
        }
        
        let teamDates = [ "Andrew" : andrewDates, "Simon" : simonDates, "Tomas" : tomasDates]
        
        Population.initializeTeams(teamDates, preferedDaysBetweenReturnGames: 90, preferedDaysBetweenConsecutieGames: 20)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPopulation() {
        
        XCTAssertEqual(Population.homeTeamArray!, ["Andrew", "Andrew", "Simon", "Simon", "Tomas", "Tomas"])
        XCTAssertEqual(Population.awayArray!, ["Simon", "Tomas", "Andrew", "Tomas", "Andrew", "Simon"])

    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
