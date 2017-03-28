
//
//  MapLayersListViewController.swift
//  TrolleyTracker
//
//  Created by Austin on 3/28/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

class MapLayersListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    fileprivate let datasource: MapLayerDataSource = .init()
    fileprivate let layerController: MapLayersController = .init()
    private var observer: ObserverSetEntry<[MapLayerItemCollection]>?

    override func viewDidLoad() {
        super.viewDidLoad()

        observer = layerController.observers.add({ [weak self] items in
            self?.datasource.setItems(items)
            self?.tableView.reloadData()
        })

        layerController.fetchMapLayers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)

        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: true)
        }
    }
}

extension MapLayersListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.sectionsCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.itemCount(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: MapLayerCell.self, for: indexPath)
        let item = datasource.item(at: indexPath)
        cell.populate(with: item)
        return cell
    }
}

extension MapLayersListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = datasource.item(at: indexPath)
        let detailVC = UIStoryboard.mapLayerDetailController(layer: item)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

