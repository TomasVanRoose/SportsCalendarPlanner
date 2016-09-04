//
//  TeamMO.swift
//  SportsCalendarPlanner
//
//  Created by Tomas Van Roose on 04/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

import Foundation
import CoreData


class TeamMO: NSManagedObject {

    class func createNewTeam(name : String, season : SeasonMO, forContext : NSManagedObjectContext) -> (TeamMO) {
        
        let team = NSEntityDescription.insertNewObjectForEntityForName("Team", inManagedObjectContext: forContext) as! TeamMO
        
        team.name = name
        team.season = season
        
        return team
    }
}
