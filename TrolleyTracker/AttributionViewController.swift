//
//  AttributionViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/27/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit


class AttributionViewController: UIViewController {
    
    fileprivate var attributionItems: [AttributionItem] = [
        AttributionItem(name: "Alamofire", url: URL(string: "https://www.github.com/Alamofire")!),
        AttributionItem(name: "ObserverSet", url: URL(string: "https://github.com/mikeash/SwiftObserverSet")!),
        AttributionItem(name: "SwiftyJSON", url: URL(string: "https://github.com/SwiftyJSON/SwiftyJSON")!)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.ttLightGray()
        navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension AttributionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributionItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttributionCell")!
        let item = attributionItems[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
}

extension AttributionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = attributionItems[(indexPath as NSIndexPath).row]
        UIApplication.shared.openURL(item.url)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // This removes cell separator lines from the portion of the tableView where there are no cells.
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

private struct AttributionItem {
    let name: String
    let url: URL
}
