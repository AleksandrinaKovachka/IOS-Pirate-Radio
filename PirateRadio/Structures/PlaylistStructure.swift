//
//  PlaylistStructure.swift
//  PirateRadio
//
//  Created by A-Team Intern on 20.07.21.
//

import Foundation

struct PlaylistStruct : Codable{
    let title: String
    let videos: [PlaylistVideosStruct]
}

struct PlaylistVideosStruct : Codable {
    let videoId: String
    let videoTitle: String
    let videoImage: String?
}
