//
//  CreatePlaylistViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 20.07.21.
//

import UIKit
import Toast_Swift

protocol SongsDelegate {
    func addSong(songKey: String, songTitle: String)
    func deleteSong(songKey: String)
    func addYouTubeSong(data: PlaylistVideosStruct)
    func deleteYoutubeSong(songTitle: String)
}

class CreatePlaylistViewController: UIViewController, SongsDelegate {
    
    var isYoutubePlaylist: Bool = false
    
    weak var selectSongsController: SelectSongsTableViewController!
    
    var playlistSongs: [String: String] = [:]
    
    var playlistYouTubeSongs: [PlaylistVideosStruct] = []

    @IBOutlet weak var playlistNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func addSong(songKey: String, songTitle: String) {
        self.playlistSongs[songKey] = songTitle
    }
    
    func deleteSong(songKey: String) {
        self.playlistSongs.removeValue(forKey: songKey)
    }
    
    func deleteYoutubeSong(songTitle: String) {
        var index: Int = 0
        for data in self.playlistYouTubeSongs {
            if data.videoTitle == songTitle {
                break
            }
            index += 1
        }
        
        self.playlistYouTubeSongs.remove(at: index)
    }
    
    func addYouTubeSong(data: PlaylistVideosStruct) {
        self.playlistYouTubeSongs.append(data)
    }

    @IBAction func createPlaylistOnAction(_ sender: Any) {
        
        var toastMessage: String = ""
        if self.playlistNameTextField.text == "" {
            toastMessage = "Input name"
            
        } else if self.playlistNameTextField.text == "New Playlist..." {
            toastMessage.append(", different form New Playlist...!")
        }
        
        if self.isYoutubePlaylist {
            if self.playlistYouTubeSongs.count == 0 {
                toastMessage.append("\nSelect at least one song!")
            }
        } else {
            if self.playlistSongs.count == 0 {
                toastMessage.append("\nSelect at least one song!")
            }
        }
        
        if toastMessage == "" {
            savePlaylistData()
        } else {
            self.view.makeToast(toastMessage, duration: 2.0, position: ToastPosition.center)
        }
    }
    
    func savePlaylistData() {
        if self.isYoutubePlaylist {
            
            if let playlistData = UserDefaults.standard.object(forKey: "PlaylistTitlesAndSongsFromYouTube") as? Data {
                if var loadedPlaylistData = try? JSONDecoder().decode(Array<PlaylistStruct>.self, from: playlistData) {
                    loadedPlaylistData.append(PlaylistStruct(title: self.playlistNameTextField.text!, videos: self.playlistYouTubeSongs))
                    
                    if let encoded = try? JSONEncoder().encode(loadedPlaylistData) {
                        UserDefaults.standard.set(encoded, forKey: "PlaylistTitlesAndSongsFromYouTube")
                    }
                }
            } else {
                if let encoded = try? JSONEncoder().encode([PlaylistStruct(title: self.playlistNameTextField.text!, videos: self.playlistYouTubeSongs)]) {
                    UserDefaults.standard.set(encoded, forKey: "PlaylistTitlesAndSongsFromYouTube")
                }
            }
        } else {
            if var playlistData = UserDefaults.standard.object(forKey: "PlaylistTitlesAndSongs") as? [String: [String: String]] {
                playlistData[self.playlistNameTextField.text!] = self.playlistSongs
                UserDefaults.standard.set(playlistData, forKey: "PlaylistTitlesAndSongs")
            } else {
                UserDefaults.standard.set([self.playlistNameTextField.text: self.playlistSongs], forKey: "PlaylistTitlesAndSongs")
            }
        }
        
        NotificationCenter.default.post(name: .hasCreatePlaylist, object: nil)
        
        self.selectSongsController.searchController.dismiss(animated: true, completion: nil)
        
        self.navigationController!.popViewController(animated: true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is SelectSongsTableViewController {
            let tableView = segue.destination as! SelectSongsTableViewController
            
            tableView.isYoutubePlaylist = self.isYoutubePlaylist
            
            self.selectSongsController = tableView
            self.selectSongsController.delegate = self
        }
        
    }

}
