//
//  ScheduleHeaderView.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/27/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

typealias ScheduleHeaderViewTapAction = (_ routeID: Int) -> Void

class ScheduleHeaderView: UITableViewHeaderFooterView {
    
    var tapAction: ScheduleHeaderViewTapAction?
    fileprivate var tapGesture: UITapGestureRecognizer!
    fileprivate var displayedRouteID: Int?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        
        addSubview(titleLabel)
        let views = ["label" : titleLabel]
        let metrics = ["hMargin" : 8, "vMargin" : 4]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(hMargin)-[label]-(hMargin)-|", options: [], metrics: metrics, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(vMargin)-[label]-(vMargin)-|", options: [], metrics: metrics, views: views))
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(ScheduleHeaderView.handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displaySection(_ section: ScheduleSection) {
        titleLabel.text = section.title
        titleLabel.textColor = section.selectable ? UIColor.ttAlternateTintColor() : UIColor.black
        tapGesture.isEnabled = section.selectable
        displayedRouteID = section.selectable ? section.items.first?.routeID : nil
    }
    
    @objc fileprivate func handleTap(_ tap: UITapGestureRecognizer) {
        guard let routeID = displayedRouteID else { return }
        tapAction?(routeID)
    }
}
