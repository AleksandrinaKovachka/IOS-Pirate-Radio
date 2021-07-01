//
//  VideoStructure.swift
//  PirateRadio
//
//  Created by A-Team Intern on 28.06.21.
//

import Foundation

//video structures
struct VideoResources : Codable {
    let items : [VideoStruct]
}

struct VideoStruct : Codable {
    let id : VideoIDStruct
    let snippet : VideoSnippetStruct
}

//struct VideoStructOrdinary : VideoStruct {
//    let id : VideoIDStruct
//    let snippet : VideoSnippetStruct
//}
//
//struct VideoStructPopular : VideoStruct  {
//    let id : String
//    let snippet : VideoSnippetStruct
//}

struct VideoIDStruct : Codable {
    let videoId : String
}

struct VideoSnippetStruct : Codable {
    let publishedAt: String
    let channelId: String
    let title : String
    let description : String
    let thumbnails : ThumbnailsStruct
}

struct ThumbnailsStruct : Codable {
    let high : ThumbnailsHighStruct
}

struct ThumbnailsHighStruct : Codable {
    let url : String
}

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

//most popular videos struct
struct PopularVideoResources : Codable {
    let items : [PopularVideoStruct]
}

struct PopularVideoStruct : Codable{
    let id : String
    let snippet : VideoSnippetStruct
}

