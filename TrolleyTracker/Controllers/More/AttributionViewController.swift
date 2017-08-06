//
//  AttributionViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/27/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

class AttributionViewController: UIViewController {

    private let titleLabel: UILabel = {
        let l = UILabel().useAutolayout()
        l.text = LS.attributionTitle
        l.numberOfLines = 0
        l.font = .systemFont(ofSize: 17)
        return l
    }()
    private let tableView: UITableView = {
        let tv = UITableView().useAutolayout()
        tv.registerCell(ofType: UITableViewCell.self)
        tv.backgroundColor = .clear
        tv.tableFooterView = UIView()
        return tv
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var attributionItems: [AttributionItem] = [
        AttributionItem(name: "Anchorage",
                        urlString: "https://github.com/Raizlabs/Anchorage"),
        AttributionItem(name: "CwlResult",
                        urlString: "https://github.com/mattgallagher/CwlUtils/blob/master/Sources/CwlUtils/CwlResult.swift"),
        AttributionItem(name: "ObserverSet",
                        urlString: "https://github.com/mikeash/SwiftObserverSet"),
        AttributionItem(name: "SwiftyJSON",
                        urlString: "https://github.com/SwiftyJSON/SwiftyJSON")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ttLightGray()
        navigationController?.navigationBar.barStyle = .blackTranslucent

        setupViews()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func setupViews() {

        view.addSubview(titleLabel)
        titleLabel.horizontalAnchors == view.horizontalAnchors + 20
        titleLabel.topAnchor == topLayoutGuide.bottomAnchor + 8

        view.addSubview(tableView)
        tableView.horizontalAnchors == view.horizontalAnchors
        tableView.topAnchor == titleLabel.bottomAnchor + 8
        tableView.bottomAnchor == bottomLayoutGuide.topAnchor
    }
}

extension AttributionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return attributionItems.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueCell(ofType: UITableViewCell.self, for: indexPath)
        let item = attributionItems[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
}

extension AttributionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let item = attributionItems[indexPath.row]
        UIApplication.shared.open(item.url,
                                  options: [:],
                                  completionHandler: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // This removes cell separator lines from the portion
    // of the tableView where there are no cells.
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

private struct AttributionItem {
    let name: String
    let url: URL

    init(name: String, urlString: String) {
        self.name = name
        self.url = URL(string: urlString)!
    }
}
