//
//  AttributionViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/27/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit


class AttributionViewController: UIViewController {
    
    private var attributionItems: [AttributionItem] = [
        AttributionItem(name: "Alamofire", url: NSURL(string: "https://www.github.com/Alamofire")!),
        AttributionItem(name: "ObserverSet", url: NSURL(string: "https://github.com/mikeash/SwiftObserverSet")!),
        AttributionItem(name: "SwiftyJSON", url: NSURL(string: "https://github.com/SwiftyJSON/SwiftyJSON")!)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.ttLightGray()
        navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension AttributionViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributionItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AttributionCell")!
        let item = attributionItems[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
}

extension AttributionViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = attributionItems[indexPath.row]
        UIApplication.sharedApplication().openURL(item.url)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

private struct AttributionItem {
    let name: String
    let url: NSURL
}
