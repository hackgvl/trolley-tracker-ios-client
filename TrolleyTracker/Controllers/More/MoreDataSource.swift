//
//  MoreDataSource.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/31/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

class MoreDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    private let settingsDataSource: SettingsDataSource

    init(settingsDataSource: SettingsDataSource) {
        self.settingsDataSource = settingsDataSource
        super.init()
    }

    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return settingsDataSource.sections[section].title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueCell(ofType: UITableViewCell.self, for: indexPath)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        settingsDataSource.sections[(indexPath as NSIndexPath).section].items[(indexPath as NSIndexPath).row].action()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

