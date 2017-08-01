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

class SettingsDataSource {
    
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
    
    fileprivate func feedbackItemWithPresentationController(_ presentationController: UIViewController) -> SettingsItem {
        
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
                presentationController.present(mc, animated: true, completion: nil)
            }
            else {
                // Show error
                let controller = AlertController(title: "Error", message: "No email accounts are available on this device.", preferredStyle: UIAlertControllerStyle.alert)
                controller.tintColor = UIColor.ttAlternateTintColor()
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                controller.addAction(action)
                presentationController.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func shareItemWithPresentationController(_ presentationController: UIViewController) -> SettingsItem {
        
        return SettingsItem(title: NSLocalizedString("Tell Friends", comment: "Share Button")) {
            
            let shareSheetViewController = UIActivityViewController(activityItems: [NSLocalizedString("Check out Trolley Tracker!", comment: "Share Action"), NSLocalizedString("http://yeahthattrolley.com", comment: "Marketing URL")], applicationActivities: nil)
            shareSheetViewController.view.tintColor = UIColor.ttAlternateTintColor()
            
            presentationController.present(shareSheetViewController, animated: true, completion: nil)
        }
    }
    
    fileprivate func attributionItemWithPresentationController(_ presentationController: UIViewController) -> SettingsItem {
        
        return SettingsItem(title: NSLocalizedString("Acknowledgements", comment: "")) {
            
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AttributionViewController") as! AttributionViewController
            presentationController.navigationController!.pushViewController(controller, animated: true)
        }
    }
    
    fileprivate func aboutItemWithPresentationController(_ presentationController: UIViewController) -> SettingsItem {
        
        return SettingsItem(title: NSLocalizedString("About", comment: "")) {
            
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
            presentationController.navigationController!.pushViewController(controller, animated: true)
        }
    }
}

class SettingsMailComposeViewControllerDelegate: NSObject, MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            NSLog("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            NSLog("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            NSLog("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            NSLog("Mail sent failure: %@", [error?.localizedDescription ?? ""])
        default:
            break
        }
        
        UINavigationBar.setDefaultAppearance()
        controller.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
