//
//  SeasonMO+CoreDataProperties.swift
//  SportsCalendarPlanner
//
//  Created by Tomas Van Roose on 03/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SeasonMO {

    @NSManaged var endDate: NSDate?
    @NSManaged var name: String?
    @NSManaged var startDate: NSDate?

}
