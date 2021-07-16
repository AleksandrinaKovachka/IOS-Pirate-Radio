//
//  ChannelStructure.swift
//  PirateRadio
//
//  Created by A-Team Intern on 16.07.21.
//

import Foundation

//channel structures
struct ChannelStruct : Codable {
    let items : [ChannelItemsStruct]
}

struct ChannelItemsStruct : Codable {
    let snippet : ChannelSnippetStruct
    let statistics : ChannelStatisticsStruct
}

struct ChannelSnippetStruct : Codable {
    let title : String
    let thumbnails : ThumbnailsStruct
}

struct ChannelStatisticsStruct : Codable {
    let subscriberCount: String
}

