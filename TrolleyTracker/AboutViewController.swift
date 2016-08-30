//
//  AboutViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/28/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet var textView: UITextView! {
        didSet {
            textView.text = "TrolleyTracker is created and maintained by Code for Greenville, more information can be found at http://trackthetrolley.com \n\nTrolleyTracker is open source software that can be found at https://github.com/codeforgreenville"
            textView.font = UIFont.systemFont(ofSize: 17)
            textView.dataDetectorTypes = [UIDataDetectorTypes.link]
            textView.tintColor = UIColor.ttAlternateTintColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        view.backgroundColor = UIColor.ttLightGray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
