//
//  PlanCalendarModalViewController.swift
//  SportsCalendarPlanner
//
//  Created by Tomas Van Roose on 09/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

import UIKit

class PlanCalendarModalViewController: UIViewController {
    
    var didSaveFunc : ((consecutiveGame: Int, returnGame : Int) -> ())?
    
    @IBOutlet weak var consecutiveTextField: UITextField!
    @IBOutlet weak var returnTextField: UITextField!
    
    @IBAction func didPlanCalendar(sender: UIButton) {
        if let saveFunc = self.didSaveFunc {
            if let cons = self.consecutiveTextField.text {
                if let ret = self.returnTextField.text {
                    dismissViewControllerAnimated(true, completion: nil)
                    saveFunc(consecutiveGame: Int(cons)!, returnGame: Int(ret)!)
                }
            }
        }
    }
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
