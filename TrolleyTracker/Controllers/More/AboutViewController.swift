//
//  AboutViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/28/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    private let textView: UITextView = {
        let tv = UITextView().useAutolayout()
        tv.text = LS.openSourceTitle
        tv.font = .systemFont(ofSize: 17)
        tv.dataDetectorTypes = [.link]
        tv.tintColor = .ttAlternateTintColor()
        tv.backgroundColor = .clear
        return tv
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .blackTranslucent
        view.backgroundColor = .ttLightGray()

        view.addSubview(textView)
        textView.edgeAnchors == edgeAnchors + 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
