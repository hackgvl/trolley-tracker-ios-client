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
                self.feedbackItemWithPresentationController(self.presentationController),
                self.shareItemWithPresentationController(self.presentationController),
                self.attributionItemWithPresentationController(self.presentationController),
                self.aboutItemWithPresentationController(self.presentationController)
                ])
        ]
    }()
    
    init(presentationController: UIViewController) {
        self.presentationController = presentationController
    }
    
    private func feedbackItemWithPresentationController(presentationController: UIViewController) -> SettingsItem {
        
        return SettingsItem(title: NSLocalizedString("Feedback", comment: "Feedback Button")) {
            
            let emailTitle = "TrolleyTracker Feedback"
            let messageBody = "Hi TrolleyTracker,\n\nI have some feedback to provide about my application using experience:\n\n"
            let toRecipents = ["YeahThatTrolley@gmail.com"]
            
            if MFMailComposeViewController.canSendMail() {
                
                UINavigationBar.setLightAppearance()

                let mc: MFMailComposeViewController = MFMailComposeViewController()
                mc.view.tintColor = UIColor.ttAlternateTintColor()
                mc.setSubject(emailTitle)
                mc.setMessageBody(messageBody, isHTML: false)
                mc.setToRecipients(toRecipents)
                mc.mailComposeDelegate = self.mailDelegate
                presentationController.presentViewController(mc, animated: true, completion: nil)
            }
            else {
                // Show error
                let controller = AlertController(title: "Error", message: "No email accounts are available on this device.", preferredStyle: UIAlertControllerStyle.Alert)
                controller.tintColor = UIColor.ttAlternateTintColor()
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                controller.addAction(action)
                presentationController.presentViewController(controller, animated: true, completion: nil)
            }
        }
    }
    
    private func shareItemWithPresentationController(presentationController: UIViewController) -> SettingsItem {
        
        return SettingsItem(title: NSLocalizedString("Tell Friends", comment: "Share Button")) {
            
            let shareSheetViewController = UIActivityViewController(activityItems: [NSLocalizedString("Check out Trolley Tracker!", comment: "Share Action"), NSLocalizedString("http://yeahthattrolley.com", comment: "Marketing URL")], applicationActivities: nil)
            shareSheetViewController.view.tintColor = UIColor.ttAlternateTintColor()
            
            presentationController.presentViewController(shareSheetViewController, animated: true, completion: nil)
        }
    }
    
    private func attributionItemWithPresentationController(presentationController: UIViewController) -> SettingsItem {
        
        return SettingsItem(title: NSLocalizedString("Acknowledgements", comment: "")) {
            
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AttributionViewController") as! AttributionViewController
            presentationController.navigationController!.pushViewController(controller, animated: true)
        }
    }
    
    private func aboutItemWithPresentationController(presentationController: UIViewController) -> SettingsItem {
        
        return SettingsItem(title: NSLocalizedString("About", comment: "")) {
            
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AboutViewController") as! AboutViewController
            presentationController.navigationController!.pushViewController(controller, animated: true)
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
        
        UINavigationBar.setDefaultAppearance()
        controller.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}