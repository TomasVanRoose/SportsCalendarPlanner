//
//  SeasonMO.swift
//  SportsCalendarPlanner
//
//  Created by Tomas Van Roose on 03/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

import Foundation
import CoreData

@objc(SeasonMO)
class SeasonMO: NSManagedObject {

    class func createNewSeason(name : String, startDate: NSDate, endDate : NSDate, forContext : NSManagedObjectContext) -> (SeasonMO) {
        
        let season = NSEntityDescription.insertNewObjectForEntityForName("Season", inManagedObjectContext: forContext) as! SeasonMO
        
        
        season.name = name
        season.startDate = startDate
        season.endDate = endDate
        
        return season
    }
    
    
}
