//
//  InputTableViewController.swift
//  SportsCalendarPlanner
//
//  Created by Tomas Van Roose on 04/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

import UIKit

class InputTableViewController: UITableViewController {

    @IBOutlet weak var inputTextField: UITextField!
    
    var didInputFunc : ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func save(sender: UIBarButtonItem) {
        if let inputString = inputTextField.text {
            didInputFunc?(inputString)
            self.navigationController?.popViewControllerAnimated(true)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
