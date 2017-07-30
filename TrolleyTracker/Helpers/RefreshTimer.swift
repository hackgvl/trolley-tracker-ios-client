//
//  RefreshTimer.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/30/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation

class RefreshTimer {

    typealias Action = () -> Void

    func start() {
        timer = Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: #selector(handleTimerFired),
                                     userInfo: nil,
                                     repeats: false)
    }
    func stop() {
        timer?.invalidate()
        timer = nil
    }

    var interval: TimeInterval
    var action: Action?

    private var timer: Timer?

    init(interval: TimeInterval, action: Action? = nil) {
        self.interval = interval
        self.action = action
    }

    @objc private func handleTimerFired() {
        action?()
    }
}
