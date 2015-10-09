//
//  SettingsViewController.swift
//  SwiftQuiz
//
//  Created by Alberto Vega Gonzalez on 8/18/15.
//  Copyright (c) 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

  @IBOutlet weak var settingsView: UIView!
  var practiceMode:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override var preferredContentSize: CGSize {
    get {
      if settingsView != nil && presentingViewController != nil {
        return settingsView.sizeThatFits(presentingViewController!.view.bounds.size)
      } else {
        return super.preferredContentSize
      }
    }
    set { super.preferredContentSize = newValue }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "backToHomeViewController" {
      let hvc: HomeViewController = segue.destinationViewController as! HomeViewController
      hvc.practiceMode = practiceMode
    }
  }
    
  @IBAction func begginnerOrAdvancedSwitch(sender: UISwitch) {
    practiceMode = false
}

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 1
    
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("SettingsItem")
    as UITableViewCell!
    
    return cell
  
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
