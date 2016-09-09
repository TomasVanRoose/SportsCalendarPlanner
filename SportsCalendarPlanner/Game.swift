//
//  Game.swift
//  SportsCalendarPlanner
//
//  Created by Tomas Van Roose on 09/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

import Foundation

class Game {
    
    var homeTeam : String
    var awayTeam : String
    var date : NSDate
    
    init(homeTeam : String, awayTeam : String, date : NSDate) {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.date = date
    }
}
