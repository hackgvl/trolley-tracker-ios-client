//
//  Schedule.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/12/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import Foundation
import SwiftyJSON

//==================================================================
// MARK: - RouteTime
//==================================================================
struct RouteTime {
    let day: String
    let time: String
    
    init(day: String, time: String) {
        self.day = day; self.time = time;
    }
}

// JSON
extension RouteTime {
    
    init?(json: JSON) {
        guard let day = json[RouteTimeJSONKeys.DayOfWeek.rawValue].string else { return nil }
        guard let startTime = json[RouteTimeJSONKeys.StartTime.rawValue].string else { return nil }
        guard let endTime = json[RouteTimeJSONKeys.EndTime.rawValue].string else { return nil }
        self.day = day; self.time = startTime + " - " + endTime;
    }
    
    enum RouteTimeJSONKeys: String {
        case DayOfWeek, StartTime, EndTime
    }
}

// Dictionary
extension RouteTime {
    
    private enum RouteTimeDictionaryKeys: String {
        case day, time
    }
    
    init?(dictionary: [String : AnyObject]) {
        guard let day = dictionary[RouteTimeDictionaryKeys.day.rawValue] as? String else { return nil }
        guard let time = dictionary[RouteTimeDictionaryKeys.time.rawValue] as? String else { return nil }
        self.day = day; self.time = time;
    }
    
    func dictionaryRepresentation() -> [String : AnyObject] {
        return [RouteTimeDictionaryKeys.day.rawValue : day, RouteTimeDictionaryKeys.time.rawValue : time]
    }
}

//==================================================================
// MARK: - RouteSchedule
//==================================================================
struct RouteSchedule {
    let name: String
    let times: [RouteTime]
    
    init(name: String, times: [RouteTime]) {
        self.name = name; self.times = times;
    }
}

// JSON 
enum RouteScheduleJSONKeys: String {
    case Description, name, times
}
extension RouteSchedule {
    
    init?(json: JSON) {
        guard let name = json[RouteScheduleJSONKeys.name.rawValue].string else { return nil }
        guard let times = json[RouteScheduleJSONKeys.times.rawValue].array else { return nil }
        
        var timesStructs = [RouteTime]()
        for json in times {
            guard let timeStruct = RouteTime(json: json) else { continue }
            timesStructs.append(timeStruct)
        }

        self.name = name
        self.times = timesStructs
    }
}

// Dictionary 
extension RouteSchedule {
    
    enum RouteScheduleDictionaryKeys: String {
        case name, times
    }
    
    init?(dictionary: [String : AnyObject]) {
        guard let name = dictionary[RouteScheduleDictionaryKeys.name.rawValue] as? String else { return nil }
        guard let timesDictionaries = dictionary[RouteScheduleDictionaryKeys.times.rawValue] as? [[String : AnyObject]] else { return nil }
        
        var timesStructs = [RouteTime]()
        for dictionary in timesDictionaries {
            guard let timeStruct = RouteTime(dictionary: dictionary) else { continue }
            timesStructs.append(timeStruct)
        }
        
        self.name = name
        self.times = timesStructs
    }
    
    func dictionaryRepresentation() -> [String : AnyObject] {
        return [
            RouteScheduleDictionaryKeys.name.rawValue : name,
            RouteScheduleDictionaryKeys.times.rawValue : times.map({ $0.dictionaryRepresentation() })
        ]
    }
}
