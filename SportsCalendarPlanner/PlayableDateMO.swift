//
//  PlayableDateMO.swift
//  SportsCalendarPlanner
//
//  Created by Tomas Van Roose on 04/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

import Foundation
import CoreData


class PlayableDateMO: NSManagedObject {

    class func createPlayableData(date : NSDate, team : TeamMO, forContext : NSManagedObjectContext) -> (PlayableDateMO) {
        
        let playableDate = NSEntityDescription.insertNewObjectForEntityForName("PlayableDate", inManagedObjectContext: forContext) as! PlayableDateMO
        
        playableDate.date = date
        playableDate.team = team
        
        return playableDate
    }
    
}
