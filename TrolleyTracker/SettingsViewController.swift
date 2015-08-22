//
//  TTSettingsViewController.swift
//  TrolleyTracker
//
//  Created by Ryan Poolos on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import UIKit
import MessageUI


class TTSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
     
      self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: "Back button on settings"), style: .Done, target: self, action: "dismissSettings")
        
      self.view.addSubview(self.tableView)
      
      let views = ["tableview": self.tableView]
      
      NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableview]|", options: nil, metrics: nil, views: views))
      
      NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableview]|", options: nil, metrics: nil, views: views))
    }
 
  
  ///MARK: TableView
  
  lazy var tableView: UITableView = {
    var tableView = UITableView(frame: CGRectZero, style: .Grouped)
    
    tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
    
    return tableView
  }()
  
  /// MARK: UITableViewDataSource
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell.self), forIndexPath: indexPath) as! UITableViewCell
    
    if indexPath.section == 0 {
      cell.textLabel?.text = NSLocalizedString("Feedback", comment: "Feedback Button")
    }
    else if indexPath.section == 1 {
      cell.textLabel?.text = NSLocalizedString("Tell Friends", comment: "Share Button")
    }
    
    return cell
  }
 
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  /// MARK: UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
   
    if indexPath.section == 0 {
      giveFeedBackButton()
    }
    else if indexPath.section == 1 {
      //show share sheet
      var shareSheetViewController = UIActivityViewController(activityItems: [NSLocalizedString("Check out Trolley Tracker!", comment: "Share Action"), NSLocalizedString("http://yeahthattrolley.com", comment: "Marketing URL")], applicationActivities: nil)
      
      self.presentViewController(shareSheetViewController, animated: true, completion: nil)
    }
  }
  
  
  func giveFeedBackButton() {
   
    var emailTitle = "TrolleyTracker Feedback"
    var messageBody = "Hi TrolleyTracker,\n\nI have some feedback to provide about my application using experience:\n\n"
    var toRecipents = ["YeahThatTrolley@gmail.com"]
    
    var mc: MFMailComposeViewController = MFMailComposeViewController()
    mc.setSubject(emailTitle)
    mc.setMessageBody(messageBody, isHTML: false)
    mc.setToRecipients(toRecipents)
    mc.mailComposeDelegate = self
    self.presentViewController(mc, animated: true, completion: nil)
  }
  
  func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
    switch result.value {
    case MFMailComposeResultCancelled.value:
      NSLog("Mail cancelled")
    case MFMailComposeResultSaved.value:
      NSLog("Mail saved")
    case MFMailComposeResultSent.value:
      NSLog("Mail sent")
    case MFMailComposeResultFailed.value:
      NSLog("Mail sent failure: %@", [error.localizedDescription])
    default:
      break
    }
    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    // self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
 
 /// MARK: Actions
  
  func dismissSettings() {
    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
}