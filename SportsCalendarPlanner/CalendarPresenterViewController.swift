//
//  CalendarPresenterViewController.swift
//  SportsCalendarPlanner
//
//  Created by Tomas Van Roose on 04/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

import UIKit

class CalendarPresenterViewController: UIViewController {

    var season : SeasonMO?
    var team : TeamMO?
    
    func selectSeason(season : SeasonMO) {
        
        self.season = season
        
        let frame = CGRect(x: 10, y: 40, width: self.view.bounds.size.width, height: self.view.bounds.size.height);
        let seasonView = SeasonViewPicker.init(frame: frame, beginDate: season.startDate!, endDate: season.endDate!, dateFunc: nil)
        
        self.view.addSubview(seasonView)
        
    }
    
    func selectTeam(team : TeamMO) {
        
        self.team = team
        self.title = team.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
