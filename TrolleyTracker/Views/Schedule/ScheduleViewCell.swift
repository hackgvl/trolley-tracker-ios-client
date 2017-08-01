//
//  ScheduleViewCell.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/27/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

class ScheduleViewCell: UITableViewCell {

    private let headingLabel: UILabel = {
        let l = UILabel().useAutolayout()
        l.font = .systemFont(ofSize: 14)
        return l
    }()
    private let timesLabel: UILabel = {
        let l = UILabel().useAutolayout()
        l.font = .italicSystemFont(ofSize: 14)
        return l
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        let sv = UIStackView().useAutolayout()
        sv.axis = .vertical
        contentView.addSubview(sv)
        sv.edgeAnchors == contentView.edgeAnchors + 8

        for label in [headingLabel, timesLabel] {
            sv.addArrangedSubview(label)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayItem(_ item: ScheduleItem) {
        selectionStyle = item.selectable ? .gray : .none
        accessoryType = item.selectable ? .disclosureIndicator : .none
        headingLabel.text = item.title
        timesLabel.text = item.times.joined(separator: "\n")
    }
}
