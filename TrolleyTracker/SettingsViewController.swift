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
        
        self.view.addSubview(self.tableView)
        
        let views = ["tableview": self.tableView]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableview]|", options: [], metrics: nil, views: views))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableview]|", options: [], metrics: nil, views: views))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    ///MARK: TableView
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect.zero, style: .grouped)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        
        return tableView
    }()
    
    /// MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsDataSource.sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        let item = settingsDataSource.sections[(indexPath as NSIndexPath).section].items[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = item.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsDataSource.sections[section].items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsDataSource.sections.count
    }
    
    /// MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        settingsDataSource.sections[(indexPath as NSIndexPath).section].items[(indexPath as NSIndexPath).row].action()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// MARK: Actions
    
    func dismissSettings() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
