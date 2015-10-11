//
//  TTSettingsViewController.swift
//  TrolleyTracker
//
//  Created by Ryan Poolos on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import UIKit

class TTSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var settingsDataSource: SettingsDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
     
        settingsDataSource = SettingsDataSource(presentationController: self)
        
      self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: "Back button on settings"), style: .Done, target: self, action: "dismissSettings")
        
      self.view.addSubview(self.tableView)
      
      let views = ["tableview": self.tableView]
      
      NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableview]|", options: [], metrics: nil, views: views))
      
      NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableview]|", options: [], metrics: nil, views: views))
        
        
    }
  
  ///MARK: TableView
  
  lazy var tableView: UITableView = {
    var tableView = UITableView(frame: CGRectZero, style: .Grouped)
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
    
    return tableView
  }()
  
  /// MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsDataSource.sections[section].title
    }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell.self), forIndexPath: indexPath)
    let item = settingsDataSource.sections[indexPath.section].items[indexPath.row]
    
    cell.textLabel?.text = item.title
    
    return cell
  }
    
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settingsDataSource.sections[section].items.count
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return settingsDataSource.sections.count
  }
  
  /// MARK: UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
   
    settingsDataSource.sections[indexPath.section].items[indexPath.row].action()
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
 
 /// MARK: Actions
  
  func dismissSettings() {
    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
}
