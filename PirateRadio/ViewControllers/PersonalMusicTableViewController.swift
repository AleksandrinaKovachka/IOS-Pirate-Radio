//
//  PersonalMusicTableViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 1.07.21.
//

import UIKit
import SwiftUI

class PersonalMusicTableViewController: UITableViewController {
    
    var searchController : UISearchController!
    
    var personalMusicData: [VideoDataStruct] = []
    
    var showDownloadVideo: [String: String] = ["videoId": ""]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchController = UISearchController.init(searchResultsController: nil)
        
        self.navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        
        //get music data from user default
        initPersonalMusicData()
        
        //check if is showed downloaded video
        if self.showDownloadVideo["videoId"] != "" {
            self.onHasShowMyMusic()
        }
        
        //observed self when video is download
        NotificationCenter.default.addObserver(self, selector: #selector(onHasDownloadVideo(_:)), name: .hasDownloadVideo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onHasDeleteVideo(_:)), name: .hasDeleteVideo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onHasDismissSwiftUI(_:)), name: .hasDismissSwiftUI, object: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.personalMusicData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalMusicCell", for: indexPath) as! PersonalMusicTableViewCell

        cell.titleLabel.text = personalMusicData[indexPath.row].videoTitle
        cell.videoImage.image = UIImage.init(named: personalMusicData[indexPath.row].videoImagePath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //connect with PersonalVideoView
        
        let personalVideoView = UIHostingController(rootView: PersonalVideoView(videoResources: self.personalMusicData, index: indexPath.row, isPlaying: false))
        
        navigationController?.pushViewController(personalVideoView, animated: true)
    }

    
    // MARK: - Get image from document directory
    
    func initPersonalMusicData() {
        if let musicData = UserDefaults.standard.object(forKey: "PersonalMusicData") as? [String: String] {
            let musicKeys = [String] (musicData.keys)
            for key in musicKeys {
                personalMusicData.append(VideoDataStruct(videoId: key, videoTitle: musicData[key]!, videoImagePath: imagePathForVideoId(videoId: key), videoPath: videoPathForVideoId(videoId: key)))
            }
        }
    }
    
    func imagePathForVideoId(videoId: String) -> String {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let imageURLName = documentDirectory.appendingPathComponent(videoId + ".jpg")
        
        if FileManager.default.fileExists(atPath: imageURLName.path) {
            
            return imageURLName.path
            
        } else {
            print("the image not exist")
            return "no_image"
        }
    }
    
    func videoPathForVideoId(videoId: String) -> String {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let videoURLName = documentDirectory.appendingPathComponent(videoId + ".mp3")
        
        if FileManager.default.fileExists(atPath: videoURLName.path) {
            return videoURLName.path
            
        } else {
            print("the video not exist")
            return "no_video"
        }
    }
    
    func savedImageForVideoId(videoId: String) -> UIImage {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let imageURLName = documentDirectory.appendingPathComponent(videoId + ".jpg")
        
        if FileManager.default.fileExists(atPath: imageURLName.path) {
            
            guard let imageFromPath = UIImage(contentsOfFile: imageURLName.path) else { return UIImage(named: "no_image")!}
            return imageFromPath
            
        } else {
            print("the image not exist")
            return UIImage(named: "no_image")!
        }
    }
    
    @objc func onHasShowMyMusic() {
        
        print("scroll")
        
        let index: Int = indexOf(videoId: self.showDownloadVideo["videoId"]!)

        let indexPath = NSIndexPath(row: index, section: 0)
        tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
            
        //highlight
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as? PersonalMusicTableViewCell
        cell?.contentView.backgroundColor = UIColor.gray
    }
    
    //MARK: - Notification
    
    @objc func onHasDownloadVideo(_ notification: Notification) {
        if let data = notification.userInfo as? [String: String] {
            for (videoId, title) in data {
                personalMusicData.append(VideoDataStruct(videoId: videoId, videoTitle: title, videoImagePath: imagePathForVideoId(videoId: videoId), videoPath: videoPathForVideoId(videoId: videoId)))
                //TODO: send image path
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func onHasDeleteVideo(_ notification: Notification) {
        if let videoData = notification.userInfo as? [String: String] {
            let videoId = videoData["videoId"]!
            
            deleteVideo(videoId: videoId)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func onHasDismissSwiftUI(_ notification: Notification) {
        navigationController?.viewControllers.remove(at: 1)
    }
    
    //MARK: - Delete files
    
    func indexOf(videoId: String) -> Int {
        var index: Int = 0
        
        for videoData in self.personalMusicData {
            if videoData.videoId == videoId {
                return index
            }
            
            index += 1
        }
        
        return index
    }
    
    func deleteVideo(videoId: String) {
        
        //TODO: if videoId not exist
        
        let index: Int = indexOf(videoId: videoId)
        
        self.personalMusicData.remove(at: index)
        
        if var musicData = UserDefaults.standard.object(forKey: "PersonalMusicData") as? [String: String] {
            musicData.removeValue(forKey: videoId)
            UserDefaults.standard.set(musicData, forKey: "PersonalMusicData")
        }
        
        deleteSavedFiles(videoId: videoId)
    }
    
    func deleteSavedFiles(videoId: String) {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let videofilePath = documentURL.appendingPathComponent(videoId + ".mp3")
        let imagefilePath = documentURL.appendingPathComponent(videoId + ".jpg")
        
        do {
            try FileManager.default.removeItem(at: videofilePath)
            try FileManager.default.removeItem(at: imagefilePath)
            print("Files deleted")
            
        } catch {
            print(error)
        }
    }
    
}

extension PersonalMusicTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

    }
}
