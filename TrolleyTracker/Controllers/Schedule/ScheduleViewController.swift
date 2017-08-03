//
//  ScheduleViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/11/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

private extension ScheduleController.DisplayType {

    func displayString() -> String {
        switch self {
        case .route:
            return "By Route"
        case .day:
            return "By Day"
        }
    }
}

protocol ScheduleVCDelegate: class {
    func didSelectScheduleTypeIndex(_ index: Int)
}

class ScheduleViewController: UIViewController, UINavigationBarDelegate {

    weak var delegate: ScheduleVCDelegate?
    
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain).useAutolayout()
        tv.estimatedRowHeight = 60
        tv.rowHeight = UITableViewAutomaticDimension
        tv.registerView(ofType: ScheduleHeaderView.self)
        tv.registerCell(ofType: ScheduleViewCell.self)
        return tv
    }()

    lazy var displayTypeControl: UISegmentedControl = {
        let sc = UISegmentedControl().useAutolayout()
        sc.tintColor = UIColor.ttLightGray()
        for displayType in ScheduleController.DisplayType.all {
            let index = displayType.rawValue
            let title = displayType.displayString()
            sc.insertSegment(withTitle: title, at: index, animated: false)
        }
        sc.addTarget(self,
                     action: #selector(segmentedControlValueChanged(_:)),
                     for: .valueChanged)
        return sc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .ttLightGray()

        setupViews()
    }

    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        delegate?.didSelectScheduleTypeIndex(sender.selectedSegmentIndex)
    }

    private func setupViews() {

        navigationItem.titleView = displayTypeControl

        view.addSubview(tableView)
        tableView.edgeAnchors == view.edgeAnchors

        let barBackground = UIView().useAutolayout()
        barBackground.backgroundColor = .black
        view.addSubview(barBackground)
        barBackground.horizontalAnchors == view.horizontalAnchors
        barBackground.topAnchor == view.topAnchor
        barBackground.bottomAnchor == topLayoutGuide.bottomAnchor
    }
}
