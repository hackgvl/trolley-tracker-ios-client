//
//  ScheduleHeaderView.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/27/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

class ScheduleHeaderView: UITableViewHeaderFooterView {
    
    var tapAction: ScheduleDataSource.DisplayRouteAction?

    private var tapGesture: UITapGestureRecognizer!
    private var displayedRouteID: Int?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.horizontalAnchors == horizontalAnchors + 8
        titleLabel.verticalAnchors == verticalAnchors + 4
        
        tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(ScheduleHeaderView.handleTap(_:)))
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
    
    @objc private func handleTap(_ tap: UITapGestureRecognizer) {
        guard let routeID = displayedRouteID else { return }
        tapAction?(routeID)
    }
}
