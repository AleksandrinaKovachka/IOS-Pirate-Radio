//
//  VideoViewsStructure.swift
//  PirateRadio
//
//  Created by A-Team Intern on 16.07.21.
//

import Foundation

//video resources for views structure
struct VideoResourcesViews : Codable {
    let items : [VideoViewsStruct]
}

struct VideoViewsStruct : Codable {
    let statistics : VideoViewStatisticsStruct
    
}

struct VideoViewStatisticsStruct : Codable {
    let viewCount: String
}
