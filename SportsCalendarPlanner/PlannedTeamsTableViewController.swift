//
//  PlannedTeamsTableViewController.swift
//  SportsCalendarPlanner
//
//  Created by Tomas Van Roose on 09/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

import UIKit

class PlannedTeamsTableViewController: UITableViewController {

    let teams : [String]
    
    var plannedPresenter : PlannedCalendarPresenterViewController?
    
    required init?(coder aDecoder: NSCoder) {
        teams = [String]()
        super.init(coder: aDecoder)
    }
    
    init(teams : [String]) {
        self.teams = teams
        super.init(style: .Plain)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("team")
        if (cell == nil) {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "team")
        }
        
        cell!.textLabel!.text = teams[indexPath.row]
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        plannedPresenter?.selectTeam(teams[indexPath.row])
    }
    
}
