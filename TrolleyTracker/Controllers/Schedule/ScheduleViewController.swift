//
//  ScheduleViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/11/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

private enum ScheduleDisplayType: Int {
    case route, day
    
    fileprivate func displayString() -> String {
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

    lazy var scheduleFormattingSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl().useAutolayout()
        sc.tintColor = UIColor.ttLightGray()
        for displayType in [ScheduleDisplayType.route, ScheduleDisplayType.day] {
            let index = displayType.rawValue
            let title = displayType.displayString()
            sc.insertSegment(withTitle: title, at: index, animated: false)
        }
        sc.selectedSegmentIndex = ScheduleDisplayType.route.rawValue
        sc.addTarget(self,
                     action: #selector(segmentedControlValueChanged(_:)),
                     for: .valueChanged)
        return sc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = .ttAlternateTintColor()
        view.backgroundColor = UIColor.ttLightGray()

        navigationItem.titleView = scheduleFormattingSegmentedControl

        view.addSubview(tableView)
        tableView.edgeAnchors == view.edgeAnchors
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }

    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        delegate?.didSelectScheduleTypeIndex(sender.selectedSegmentIndex)
    }
}
