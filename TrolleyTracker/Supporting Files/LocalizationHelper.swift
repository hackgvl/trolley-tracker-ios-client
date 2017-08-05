//
//  LocalizationHelper.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/30/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation

struct LS {

    private init() {}

    static var genericErrorTitle: String {
        return string(for: "Generic.Error.Title")
    }

    static var genericOKButton: String {
        return string(for: "Generic.Button.OK")
    }

    static var mapTitle: String {
        return string(for: "Map.Title")
    }
    static var scheduleTitle: String {
        return string(for: "Schedule.Title")
    }
    static var moreTitle: String {
        return string(for: "More.Title")
    }

    static var mapMessageNoTrolleys: String {
        return string(for: "Message.NoTrolleys")
    }

    static var mapMessageDisclaimer: String {
        return string(for: "Message.Disclaimer")
    }

    static var mapUserLocationError: String {
        return string(for: "Message.Error.NoUserLocation")
    }

    static var detailDirectionsButton: String {
        return string(for: "Detail.Button.Directions")
    }
    static var detailWalkingButton: String {
        return string(for: "Detail.Button.WalkingTime")
    }
    static var detailTitleLabel: String {
        return string(for: "Detail.Label.Title")
    }

    static var moreTitleGeneral: String {
        return string(for: "More.Title.General")
    }

    static var moreItemFeedback: String {
        return string(for: "More.Item.Feedback")
    }

    static var moreItemShare: String {
        return string(for: "More.Item.Share")
    }

    static var moreItemShareTitle: String {
        return string(for: "More.Item.Share.Title")
    }

    static var moreItemShareURL: String {
        return string(for: "More.Item.Share.URL")
    }

    static var moreItemAcknowledgements: String {
        return string(for: "More.Item.Acknowledgements")
    }

    static var moreItemAbout: String {
        return string(for: "More.Item.About")
    }

    static var openSourceTitle: String {
        return string(for: "OpenSource.Title")
    }

    static var attributionTitle: String {
        return string(for: "Attribution.Title")
    }

    static var feedbackTitle: String {
        return string(for: "Feedback.Title")
    }

    static var feedbackMessage: String {
        return string(for: "Feedback.Message")
    }

    static var feedbackErrorNoMail: String {
        return string(for: "Feedback.Error.NoMail")
    }

    static var scheduleTypeRoute: String {
        return string(for: "Schedule.Type.Route")
    }

    static var scheduleTypeDay: String {
        return string(for: "Schedule.Type.Day")
    }


    private static func string(for key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
