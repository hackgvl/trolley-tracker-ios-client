//
//  TrolleyRouteFakeService.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/28/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import Foundation
import SwiftyJSON

class TrolleyRouteServiceFake: TrolleyRouteService {
    
    func loadTrolleyRoute(routeID: Int, completion: LoadTrolleyRouteCompletion) {
        let route = fakeRoutes().filter({ $0.ID == routeID }).first
        let routes = route != nil ? [route!] : [TrolleyRoute]()
        completion(routes: routes)
    }
    
    func loadTrolleyRoutes(completion: LoadTrolleyRouteCompletion) {
        
        completion(routes: fakeRoutes())
    }
    
    private func fakeRoutes() -> [TrolleyRoute] {
        return [TrolleyRoute(json: fakeRoute1(), colorIndex: 2)!]
    }
    
    private func fakeRoute1() -> JSON {
        
        let dictionary: [String : AnyObject] = [
            "ID": 1,
            "ShortName": "ShortMain",
            "LongName": "Main Street short",
            "Description": "North Main Street to Fluor Field - no Heritage Green",
            "FlagStopsOnly": false,
            "Stops": [
                [
                    "ID": 44,
                    "Name": "S Richardson St @ Transit Center",
                    "Description": "S Richardson St @ Transit Center",
                    "Lat": 34.850448,
                    "Lon": -82.4010785
                ],
                [
                    "ID": 43,
                    "Name": "River St @ West Court St",
                    "Description": "River St @ West Court St",
                    "Lat": 34.8493456,
                    "Lon": -82.4019878
                ],
                [
                    "ID": 31,
                    "Name": "S Main @ Wells Fargo Plaza",
                    "Description": "S Main @ Wells Fargo Plaza",
                    "Lat": 34.8503157,
                    "Lon": -82.3992308
                ],
                [
                    "ID": 32,
                    "Name": "S Main @ Poinsett Plaza",
                    "Description": "S Main @ Poinsett Plaza",
                    "Lat": 34.8491211,
                    "Lon": -82.3997923
                ],
                [
                    "ID": 33,
                    "Name": "S Main @ City Hall",
                    "Description": "S Main @ City Hall",
                    "Lat": 34.8482581,
                    "Lon": -82.4002633
                ],
                [
                    "ID": 34,
                    "Name": "S Main @ Village Green",
                    "Description": "S Main @ Village Green",
                    "Lat": 34.8477894,
                    "Lon": -82.4003879
                ],
                [
                    "ID": 35,
                    "Name": "S Main @ Peace Center",
                    "Description": "S Main @ Peace Center",
                    "Lat": 34.8466131,
                    "Lon": -82.400934
                ],
                [
                    "ID": 36,
                    "Name": "S Main @ Falls Park",
                    "Description": "S Main @ Falls Park",
                    "Lat": 34.8453763,
                    "Lon": -82.4019207
                ],
                [
                    "ID": 37,
                    "Name": "S Main @ Pomegranate",
                    "Description": "S Main @ Pomegranate",
                    "Lat": 34.8447334,
                    "Lon": -82.402793
                ],
                [
                    "ID": 38,
                    "Name": "S Main @ Rick Erwin",
                    "Description": "S Main @ Rick Erwin",
                    "Lat": 34.844639,
                    "Lon": -82.4036105
                ],
                [
                    "ID": 30,
                    "Name": "N Main @ Certus Bank",
                    "Description": "N Main @ Certus Bank",
                    "Lat": 34.8512226,
                    "Lon": -82.3988049
                ],
                [
                    "ID": 29,
                    "Name": "N Main @ Mast General Store",
                    "Description": "N Main @ Mast General Store",
                    "Lat": 34.8520171,
                    "Lon": -82.3984516
                ],
                [
                    "ID": 28,
                    "Name": "N Main @ NOMA Square",
                    "Description": "N Main @ NOMA Square",
                    "Lat": 34.8531554,
                    "Lon": -82.3979107
                ],
                [
                    "ID": 27,
                    "Name": "Towers East Apts",
                    "Description": "Towers East Apts",
                    "Lat": 34.8558375,
                    "Lon": -82.3968439
                ],
                [
                    "ID": 26,
                    "Name": "619 N Main",
                    "Description": "619 N Main",
                    "Lat": 34.8595832,
                    "Lon": -82.3952439
                ],
                [
                    "ID": 25,
                    "Name": "N Main @ Thomas McAfee",
                    "Description": "N Main @ Thomas McAfee",
                    "Lat": 34.8602415,
                    "Lon": -82.3950161
                ],
                [
                    "ID": 24,
                    "Name": "N Main @ Bohemian Cafe",
                    "Description": "N Main @ Bohemian Cafe",
                    "Lat": 34.8619016,
                    "Lon": -82.3942142
                ],
                [
                    "ID": 45,
                    "Name": "Richardson St @ W North St",
                    "Description": "Richardson St @ W North St",
                    "Lat": 34.8528676,
                    "Lon": -82.3998933
                ],
                [
                    "ID": 42,
                    "Name": "S Main @ American Grocery",
                    "Description": "S Main @ American Grocery",
                    "Lat": 34.8442468,
                    "Lon": -82.4050237
                ],
                [
                    "ID": 41,
                    "Name": "S Main @ Compadres",
                    "Description": "S Main @ Compadres",
                    "Lat": 34.8433129,
                    "Lon": -82.4082198
                ],
                [
                    "ID": 40,
                    "Name": "Greenville Drive Ticket Office",
                    "Description": "Greenville Drive Ticket Office",
                    "Lat": 34.8428768,
                    "Lon": -82.4092208
                ],
                [
                    "ID": 39,
                    "Name": "Fluor Field",
                    "Description": "Fluor Field",
                    "Lat": 34.8416466,
                    "Lon": -82.407466
                ]
            ],
            "RouteShape": [
                [
                    "Lat": 34.8512766,
                    "Lon": -82.4006823
                ],
                [
                    "Lat": 34.8511927,
                    "Lon": -82.4007197
                ],
                [
                    "Lat": 34.8507494,
                    "Lon": -82.4009175
                ],
                [
                    "Lat": 34.85068,
                    "Lon": -82.4009712
                ],
                [
                    "Lat": 34.8506107,
                    "Lon": -82.4010315
                ],
                [
                    "Lat": 34.8505403,
                    "Lon": -82.4011173
                ],
                [
                    "Lat": 34.8504775,
                    "Lon": -82.4012045
                ],
                [
                    "Lat": 34.8503642,
                    "Lon": -82.4013695
                ],
                [
                    "Lat": 34.85025,
                    "Lon": -82.4015094
                ],
                [
                    "Lat": 34.85025,
                    "Lon": -82.4015094
                ],
                [
                    "Lat": 34.850193,
                    "Lon": -82.4015847
                ],
                [
                    "Lat": 34.8501292,
                    "Lon": -82.401641
                ],
                [
                    "Lat": 34.850061,
                    "Lon": -82.4016799
                ],
                [
                    "Lat": 34.850061,
                    "Lon": -82.4016799
                ],
                [
                    "Lat": 34.8492822,
                    "Lon": -82.4020625
                ],
                [
                    "Lat": 34.8492141,
                    "Lon": -82.4020964
                ],
                [
                    "Lat": 34.8492141,
                    "Lon": -82.4020964
                ],
                [
                    "Lat": 34.8490935,
                    "Lon": -82.4021634
                ],
                [
                    "Lat": 34.8489769,
                    "Lon": -82.4022439
                ],
                [
                    "Lat": 34.8489769,
                    "Lon": -82.4022439
                ],
                [
                    "Lat": 34.8489294,
                    "Lon": -82.4022956
                ],
                [
                    "Lat": 34.8489294,
                    "Lon": -82.4022956
                ],
                [
                    "Lat": 34.8488921,
                    "Lon": -82.4023453
                ],
                [
                    "Lat": 34.8486125,
                    "Lon": -82.4027172
                ],
                [
                    "Lat": 34.848518,
                    "Lon": -82.402843
                ],
                [
                    "Lat": 34.848518,
                    "Lon": -82.402843
                ],
                [
                    "Lat": 34.848372,
                    "Lon": -82.403049
                ],
                [
                    "Lat": 34.8482573,
                    "Lon": -82.4032
                ],
                [
                    "Lat": 34.8482573,
                    "Lon": -82.4032
                ],
                [
                    "Lat": 34.848224,
                    "Lon": -82.4032486
                ],
                [
                    "Lat": 34.8481977,
                    "Lon": -82.403277
                ],
                [
                    "Lat": 34.8481435,
                    "Lon": -82.4033269
                ],
                [
                    "Lat": 34.848032,
                    "Lon": -82.403413
                ],
                [
                    "Lat": 34.847512,
                    "Lon": -82.403757
                ],
                [
                    "Lat": 34.847171,
                    "Lon": -82.403983
                ],
                [
                    "Lat": 34.8467981,
                    "Lon": -82.4042084
                ],
                [
                    "Lat": 34.846764,
                    "Lon": -82.404229
                ],
                [
                    "Lat": 34.846642,
                    "Lon": -82.40429
                ],
                [
                    "Lat": 34.84653,
                    "Lon": -82.404319
                ],
                [
                    "Lat": 34.84653,
                    "Lon": -82.404319
                ],
                [
                    "Lat": 34.846353,
                    "Lon": -82.404338
                ],
                [
                    "Lat": 34.8462646,
                    "Lon": -82.404344
                ],
                [
                    "Lat": 34.845478,
                    "Lon": -82.404397
                ],
                [
                    "Lat": 34.845478,
                    "Lon": -82.404397
                ],
                [
                    "Lat": 34.8453134,
                    "Lon": -82.4043812
                ],
                [
                    "Lat": 34.844992,
                    "Lon": -82.404324
                ],
                [
                    "Lat": 34.844619,
                    "Lon": -82.4042173
                ],
                [
                    "Lat": 34.84459,
                    "Lon": -82.404209
                ],
                [
                    "Lat": 34.844521,
                    "Lon": -82.404215
                ],
                [
                    "Lat": 34.844521,
                    "Lon": -82.404215
                ],
                [
                    "Lat": 34.844473,
                    "Lon": -82.404229
                ],
                [
                    "Lat": 34.844406,
                    "Lon": -82.404275
                ],
                [
                    "Lat": 34.8441825,
                    "Lon": -82.4045141
                ],
                [
                    "Lat": 34.84409,
                    "Lon": -82.404614
                ],
                [
                    "Lat": 34.843726,
                    "Lon": -82.404983
                ],
                [
                    "Lat": 34.843453,
                    "Lon": -82.405245
                ],
                [
                    "Lat": 34.843372,
                    "Lon": -82.405325
                ],
                [
                    "Lat": 34.843052,
                    "Lon": -82.405586
                ],
                [
                    "Lat": 34.842519,
                    "Lon": -82.4059946
                ],
                [
                    "Lat": 34.842452,
                    "Lon": -82.406046
                ],
                [
                    "Lat": 34.842057,
                    "Lon": -82.406315
                ],
                [
                    "Lat": 34.841948,
                    "Lon": -82.40636
                ],
                [
                    "Lat": 34.8417973,
                    "Lon": -82.4063993
                ],
                [
                    "Lat": 34.8417225,
                    "Lon": -82.4064188
                ],
                [
                    "Lat": 34.8507403,
                    "Lon": -82.3989856
                ],
                [
                    "Lat": 34.8506693,
                    "Lon": -82.3990179
                ],
                [
                    "Lat": 34.8506412,
                    "Lon": -82.3990306
                ],
                [
                    "Lat": 34.8496109,
                    "Lon": -82.3994984
                ],
                [
                    "Lat": 34.8495248,
                    "Lon": -82.3995375
                ],
                [
                    "Lat": 34.8492914,
                    "Lon": -82.3996435
                ],
                [
                    "Lat": 34.8488156,
                    "Lon": -82.3998595
                ],
                [
                    "Lat": 34.8487026,
                    "Lon": -82.3999109
                ],
                [
                    "Lat": 34.8486664,
                    "Lon": -82.3999273
                ],
                [
                    "Lat": 34.8485024,
                    "Lon": -82.4000017
                ],
                [
                    "Lat": 34.8483374,
                    "Lon": -82.4000767
                ],
                [
                    "Lat": 34.8479487,
                    "Lon": -82.4002528
                ],
                [
                    "Lat": 34.847705499999996,
                    "Lon": -82.4003635
                ],
                [
                    "Lat": 34.8475797,
                    "Lon": -82.4004207
                ],
                [
                    "Lat": 34.8474487,
                    "Lon": -82.4004802
                ],
                [
                    "Lat": 34.8464867,
                    "Lon": -82.400917
                ],
                [
                    "Lat": 34.8464867,
                    "Lon": -82.400917
                ],
                [
                    "Lat": 34.846392,
                    "Lon": -82.400971
                ],
                [
                    "Lat": 34.8461845,
                    "Lon": -82.4011174
                ],
                [
                    "Lat": 34.8461845,
                    "Lon": -82.4011174
                ],
                [
                    "Lat": 34.845958,
                    "Lon": -82.401324
                ],
                [
                    "Lat": 34.845895,
                    "Lon": -82.401377
                ],
                [
                    "Lat": 34.845834,
                    "Lon": -82.40143
                ],
                [
                    "Lat": 34.8455653,
                    "Lon": -82.4016592
                ],
                [
                    "Lat": 34.8455653,
                    "Lon": -82.4016592
                ],
                [
                    "Lat": 34.845494,
                    "Lon": -82.40172
                ],
                [
                    "Lat": 34.8451446,
                    "Lon": -82.4020518
                ],
                [
                    "Lat": 34.844934,
                    "Lon": -82.402251
                ],
                [
                    "Lat": 34.844857,
                    "Lon": -82.40235
                ],
                [
                    "Lat": 34.844755,
                    "Lon": -82.40253
                ],
                [
                    "Lat": 34.8447009,
                    "Lon": -82.4026392
                ],
                [
                    "Lat": 34.8446767,
                    "Lon": -82.4027505
                ],
                [
                    "Lat": 34.844664,
                    "Lon": -82.402825
                ],
                [
                    "Lat": 34.844631,
                    "Lon": -82.403026
                ],
                [
                    "Lat": 34.8445617,
                    "Lon": -82.4037552
                ],
                [
                    "Lat": 34.844521,
                    "Lon": -82.404215
                ],
                [
                    "Lat": 34.8507403,
                    "Lon": -82.3989856
                ],
                [
                    "Lat": 34.8508232,
                    "Lon": -82.3989461
                ],
                [
                    "Lat": 34.8515463,
                    "Lon": -82.3986011
                ],
                [
                    "Lat": 34.8515463,
                    "Lon": -82.3986011
                ],
                [
                    "Lat": 34.8524767,
                    "Lon": -82.398182
                ],
                [
                    "Lat": 34.8539543,
                    "Lon": -82.3975115
                ],
                [
                    "Lat": 34.8539543,
                    "Lon": -82.3975115
                ],
                [
                    "Lat": 34.8540729,
                    "Lon": -82.39748
                ],
                [
                    "Lat": 34.854146,
                    "Lon": -82.397464
                ],
                [
                    "Lat": 34.854588,
                    "Lon": -82.397282
                ],
                [
                    "Lat": 34.854858,
                    "Lon": -82.397156
                ],
                [
                    "Lat": 34.854858,
                    "Lon": -82.397156
                ],
                [
                    "Lat": 34.854962,
                    "Lon": -82.3971008
                ],
                [
                    "Lat": 34.855293,
                    "Lon": -82.396958
                ],
                [
                    "Lat": 34.8570122,
                    "Lon": -82.3962211
                ],
                [
                    "Lat": 34.85715,
                    "Lon": -82.396162
                ],
                [
                    "Lat": 34.85715,
                    "Lon": -82.396162
                ],
                [
                    "Lat": 34.8572429,
                    "Lon": -82.3961232
                ],
                [
                    "Lat": 34.857724,
                    "Lon": -82.395922
                ],
                [
                    "Lat": 34.8581325,
                    "Lon": -82.3957502
                ],
                [
                    "Lat": 34.8581408,
                    "Lon": -82.3957468
                ],
                [
                    "Lat": 34.858231,
                    "Lon": -82.39571
                ],
                [
                    "Lat": 34.858231,
                    "Lon": -82.39571
                ],
                [
                    "Lat": 34.8583026,
                    "Lon": -82.3956795
                ],
                [
                    "Lat": 34.859888,
                    "Lon": -82.395005
                ],
                [
                    "Lat": 34.8604683,
                    "Lon": -82.394752
                ],
                [
                    "Lat": 34.861544,
                    "Lon": -82.394283
                ],
                [
                    "Lat": 34.861544,
                    "Lon": -82.394283
                ],
                [
                    "Lat": 34.862797,
                    "Lon": -82.393742
                ],
                [
                    "Lat": 34.862797,
                    "Lon": -82.393742
                ],
                [
                    "Lat": 34.863003,
                    "Lon": -82.395912
                ],
                [
                    "Lat": 34.854524,
                    "Lon": -82.398794
                ],
                [
                    "Lat": 34.85431,
                    "Lon": -82.398929
                ],
                [
                    "Lat": 34.854085,
                    "Lon": -82.399121
                ],
                [
                    "Lat": 34.853918,
                    "Lon": -82.399292
                ],
                [
                    "Lat": 34.85375,
                    "Lon": -82.3994669
                ],
                [
                    "Lat": 34.853545,
                    "Lon": -82.399636
                ],
                [
                    "Lat": 34.853366,
                    "Lon": -82.399751
                ],
                [
                    "Lat": 34.853233,
                    "Lon": -82.399817
                ],
                [
                    "Lat": 34.8529968,
                    "Lon": -82.3999247
                ],
                [
                    "Lat": 34.844521,
                    "Lon": -82.404215
                ],
                [
                    "Lat": 34.8444546,
                    "Lon": -82.4044559
                ],
                [
                    "Lat": 34.8443957,
                    "Lon": -82.4046618
                ],
                [
                    "Lat": 34.8442789,
                    "Lon": -82.4050744
                ],
                [
                    "Lat": 34.8441,
                    "Lon": -82.4057166
                ],
                [
                    "Lat": 34.8437897,
                    "Lon": -82.4068233
                ],
                [
                    "Lat": 34.8435696,
                    "Lon": -82.4076083
                ],
                [
                    "Lat": 34.8431161,
                    "Lon": -82.4092238
                ],
                [
                    "Lat": 34.843083,
                    "Lon": -82.409344
                ],
                [
                    "Lat": 34.843083,
                    "Lon": -82.409344
                ],
                [
                    "Lat": 34.8429736,
                    "Lon": -82.4092959
                ],
                [
                    "Lat": 34.842127,
                    "Lon": -82.40896
                ],
                [
                    "Lat": 34.842127,
                    "Lon": -82.40896
                ],
                [
                    "Lat": 34.8414045,
                    "Lon": -82.4086855
                ],
                [
                    "Lat": 34.8413229,
                    "Lon": -82.4086575
                ],
                [
                    "Lat": 34.8413229,
                    "Lon": -82.4086575
                ],
                [
                    "Lat": 34.841604,
                    "Lon": -82.407404
                ],
                [
                    "Lat": 34.8416568,
                    "Lon": -82.4070651
                ],
                [
                    "Lat": 34.8416888,
                    "Lon": -82.406861
                ],
                [
                    "Lat": 34.8417035,
                    "Lon": -82.4067203
                ],
                [
                    "Lat": 34.8417213,
                    "Lon": -82.406557
                ],
                [
                    "Lat": 34.8417222,
                    "Lon": -82.4065174
                ],
                [
                    "Lat": 34.8417225,
                    "Lon": -82.4064188
                ],
                [
                    "Lat": 34.854524,
                    "Lon": -82.398794
                ],
                [
                    "Lat": 34.8549102,
                    "Lon": -82.3986459
                ],
                [
                    "Lat": 34.8552753,
                    "Lon": -82.398506
                ],
                [
                    "Lat": 34.8552753,
                    "Lon": -82.398506
                ],
                [
                    "Lat": 34.855416,
                    "Lon": -82.398457
                ],
                [
                    "Lat": 34.855416,
                    "Lon": -82.398457
                ],
                [
                    "Lat": 34.85569,
                    "Lon": -82.398354
                ],
                [
                    "Lat": 34.856403,
                    "Lon": -82.398103
                ],
                [
                    "Lat": 34.857666,
                    "Lon": -82.397668
                ],
                [
                    "Lat": 34.858066,
                    "Lon": -82.397535
                ],
                [
                    "Lat": 34.858579,
                    "Lon": -82.397365
                ],
                [
                    "Lat": 34.858579,
                    "Lon": -82.397365
                ],
                [
                    "Lat": 34.858706,
                    "Lon": -82.397352
                ],
                [
                    "Lat": 34.859272,
                    "Lon": -82.39718
                ],
                [
                    "Lat": 34.85939,
                    "Lon": -82.397134
                ],
                [
                    "Lat": 34.860346,
                    "Lon": -82.39669
                ],
                [
                    "Lat": 34.860794,
                    "Lon": -82.396485
                ],
                [
                    "Lat": 34.86159,
                    "Lon": -82.39611
                ],
                [
                    "Lat": 34.861714,
                    "Lon": -82.396078
                ],
                [
                    "Lat": 34.863003,
                    "Lon": -82.395912
                ],
                [
                    "Lat": 34.8512766,
                    "Lon": -82.4006823
                ],
                [
                    "Lat": 34.8513617,
                    "Lon": -82.4006448
                ],
                [
                    "Lat": 34.852291,
                    "Lon": -82.4002356
                ],
                [
                    "Lat": 34.8523937,
                    "Lon": -82.4001903
                ],
                [
                    "Lat": 34.8524809,
                    "Lon": -82.4001519
                ],
                [
                    "Lat": 34.8529968,
                    "Lon": -82.3999247
                ]
            ]
        ]
        
        
        return JSON(dictionary)
    }
}