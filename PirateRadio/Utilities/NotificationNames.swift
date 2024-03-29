//
//  NotificationNames.swift
//  PirateRadio
//
//  Created by A-Team Intern on 7.07.21.
//

import Foundation

extension Notification.Name {
    static let hasDownloadVideo = Notification.Name("hasDownloadVideo")
    static let hasDeleteVideo = Notification.Name("hasDeleteVideo")
    static let hasDismissSwiftUI = Notification.Name("hasDismissSwiftUI")
    static let didVideoFinished = Notification.Name("didVideoFinished")
    static let didPlayMusic = Notification.Name("DidPlayMusic")
    static let didShuffleMusic = Notification.Name("DidShuffleMusic")
    static let hasCreatePlaylist = Notification.Name("HasCreatePlaylist")
    static let didSearchSongs = Notification.Name("DidSearchSongs")
    static let didCancelSearchSongs = Notification.Name("DidCancelSearchSongs")
}
