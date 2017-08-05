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
            SettingsSection(title: LS.moreTitleGeneral, items: [
                self.feedbackItem(with: self.presentationController),
                self.shareItem(with:self.presentationController),
                self.attributionItem(with: self.presentationController),
                self.aboutItem(with: self.presentationController)
                ])
        ]
    }()
    
    init(presentationController: UIViewController) {
        self.presentationController = presentationController
    }
    
    fileprivate func feedbackItem(with context: UIViewController) -> SettingsItem {
        
        return SettingsItem(title: LS.moreItemFeedback) {

            guard MFMailComposeViewController.canSendMail() else {
                let controller = AlertController.errorPopup(with: LS.feedbackErrorNoMail)
                context.present(controller, animated: true, completion: nil)
                return
            }

            AppearanceHelper.setLightNavigationColors()

            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.view.tintColor = .ttAlternateTintColor()
            mc.setSubject(LS.feedbackTitle)
            mc.setMessageBody(LS.feedbackMessage, isHTML: false)
            mc.setToRecipients(["YeahThatTrolley@gmail.com"])
            mc.mailComposeDelegate = self.mailDelegate

            context.present(mc, animated: true, completion: nil)
        }
    }
    
    fileprivate func shareItem(with context: UIViewController) -> SettingsItem {
        
        return SettingsItem(title: LS.moreItemShare) {

            let items = [LS.moreItemShareTitle, LS.moreItemShareURL]
            let controller = UIActivityViewController(activityItems: items,
                                                      applicationActivities: nil)

            context.present(controller, animated: true, completion: nil)
        }
    }
    
    fileprivate func attributionItem(with context: UIViewController) -> SettingsItem {
        
        return SettingsItem(title: LS.moreItemAcknowledgements) {
            let controller = AttributionViewController()
            let nav = context.navigationController
            nav?.pushViewController(controller, animated: true)
        }
    }
    
    fileprivate func aboutItem(with context: UIViewController) -> SettingsItem {
        
        return SettingsItem(title: LS.moreItemAbout) {
            let controller = AboutViewController()
            let nav = context.navigationController
            nav?.pushViewController(controller, animated: true)
        }
    }
}

class SettingsMailComposeViewControllerDelegate: NSObject, MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller:MFMailComposeViewController,
                               didFinishWith result:MFMailComposeResult,
                               error:Error?) {
        
        AppearanceHelper.setDefaultNavigationAppearance()
        controller.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
