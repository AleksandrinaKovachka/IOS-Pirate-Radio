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
}

struct VideoIDStruct: Codable {
    let videoId : String
}




