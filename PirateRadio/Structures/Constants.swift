//
//  Constants.swift
//  PirateRadio
//
//  Created by A-Team Intern on 28.06.21.
//

import Foundation

struct Constants {
    
    static var API_KEY = "AIzaSyB87qFXNhBgmgkCVfqDLiVoTWdpAernyMQ"
    static var LIST = "PLEkRYDcpWohyGXyg3tozA5I6glhPcM0mD"
    static var URL = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(Constants.LIST)&key=\(Constants.API_KEY)"
    
}
