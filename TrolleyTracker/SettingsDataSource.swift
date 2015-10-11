//
//  SettingsDataSource.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/11/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit
import MessageUI

struct SettingsItem {
    
    let title: String
    let action: () -> Void
}

struct SettingsSection {
    let title: String?
    let items: [SettingsItem]
}

struct SettingsDataSource {
    
    let presentationController: UIViewController
    let mailDelegate = SettingsMailComposeViewControllerDelegate()
    
    lazy var sections: [SettingsSection] = {
        
        return [
            SettingsSection(title: "General", items: [
                self.scheduleItemWithPresentationController(self.presentationController),
                self.feedbackItemWithPresentationController(self.presentationController),
                self.shareItemWithPresentationController(self.presentationController)
                ])
        ]
    }()
    
    init(presentationController: UIViewController) {
        self.presentationController = presentationController
    }
    
    private func feedbackItemWithPresentationController(controller: UIViewController) -> SettingsItem {
        
        return SettingsItem(title: NSLocalizedString("Feedback", comment: "Feedback Button")) {
            
            let emailTitle = "TrolleyTracker Feedback"
            let messageBody = "Hi TrolleyTracker,\n\nI have some feedback to provide about my application using experience:\n\n"
            let toRecipents = ["YeahThatTrolley@gmail.com"]
            
            if MFMailComposeViewController.canSendMail() {
                let mc: MFMailComposeViewController = MFMailComposeViewController()
                mc.setSubject(emailTitle)
                mc.setMessageBody(messageBody, isHTML: false)
                mc.setToRecipients(toRecipents)
                mc.mailComposeDelegate = self.mailDelegate
                controller.presentViewController(mc, animated: true, completion: nil)
            }
            else {
                // Show error
                let controller = UIAlertController(title: "Error", message: "No email accounts are available on this device.", preferredStyle: UIAlertControllerStyle.Alert)
                controller.view.tintColor = UIColor.ttAlternateTintColor()
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                controller.addAction(action)
                controller.presentViewController(controller, animated: true, completion: nil)
            }
        }
    }
    
    private func scheduleItemWithPresentationController(controller: UIViewController) -> SettingsItem {
        
        return SettingsItem(title: "Trolley Schedule") {
            
            guard let scheduleController = UIStoryboard(name: "Schedule", bundle: nil).instantiateInitialViewController() else { return }

            if let navigationController = self.presentationController.navigationController {
                navigationController.pushViewController(scheduleController, animated: true)
            }
            else {
                self.presentationController.presentViewController(scheduleController, animated: true, completion: nil)
            }
        }
    }
    
    private func shareItemWithPresentationController(controller: UIViewController) -> SettingsItem {
        
        return SettingsItem(title: NSLocalizedString("Tell Friends", comment: "Share Button")) {
            
            let shareSheetViewController = UIActivityViewController(activityItems: [NSLocalizedString("Check out Trolley Tracker!", comment: "Share Action"), NSLocalizedString("http://yeahthattrolley.com", comment: "Marketing URL")], applicationActivities: nil)
            
            controller.presentViewController(shareSheetViewController, animated: true, completion: nil)
        }
    }
}

class SettingsMailComposeViewControllerDelegate: NSObject, MFMailComposeViewControllerDelegate {
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            NSLog("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            NSLog("Mail saved")
        case MFMailComposeResultSent.rawValue:
            NSLog("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            NSLog("Mail sent failure: %@", [error?.localizedDescription ?? ""])
        default:
            break
        }
        
        controller.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}