//
//  VideoStructure.swift
//  PirateRadio
//
//  Created by A-Team Intern on 28.06.21.
//

import Foundation

struct VideoResources : Codable {
    let items : [VideoStruct]
}

struct VideoStruct : Codable{
    let id : VideoIDStruct
    let snippet : VideoSnippetStruct
}

struct VideoIDStruct : Codable {
    let videoId : String
}

struct VideoSnippetStruct : Codable {
    let publishedAt: String
    let title : String
    let description : String
    let thumbnails : VideoThumbnailsStruct
}

struct VideoThumbnailsStruct : Codable {
    let high : VideoThumbnailsHighStruct
}

struct VideoThumbnailsHighStruct : Codable {
    let url : String
}




