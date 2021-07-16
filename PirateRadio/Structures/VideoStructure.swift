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

//most popular videos struct
struct PopularVideoResources : Codable {
    let items : [PopularVideoStruct]
}

struct PopularVideoStruct : Codable{
    let id : String
    let snippet : VideoSnippetStruct
}

//structure for video data
struct VideoDataStruct {
    var videoId: String
    var videoTitle: String
    var videoImagePath: String
    var videoPath: String
}

