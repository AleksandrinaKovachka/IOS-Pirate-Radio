//
//  CreatePlaylistViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 20.07.21.
//

import UIKit

protocol SongsDelegate {
    func addSong(songKey: String, songTitle: String)
    func deleteSong(songKey: String)
}

class CreatePlaylistViewController: UIViewController, SongsDelegate {
    
    weak var selectSongsController: SelectSongsTableViewController!
    
    var playlistSongs: [String: String] = [:]

    @IBOutlet weak var playlistNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func addSong(songKey: String, songTitle: String) {
        self.playlistSongs[songKey] = songTitle
    }
    
    func deleteSong(songKey: String) {
        self.playlistSongs.removeValue(forKey: songKey)
    }

    @IBAction func createPlaylistOnAction(_ sender: Any) {
        
        if var playlistData = UserDefaults.standard.object(forKey: "PlaylistTitlesAndSongs") as? [PlaylistStruct] {
            playlistData.append(PlaylistStruct(title: self.playlistNameTextField.text!, songs: self.playlistSongs))
            UserDefaults.standard.set(playlistData, forKey: "PlaylistTitlesAndSongs")
        } else {
            UserDefaults.standard.set(PlaylistStruct(title: self.playlistNameTextField.text!, songs: self.playlistSongs), forKey: "PlaylistTitlesAndSongs")
        }
        
        //notify to update table with playlist
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectSongsTableView"{
            let tableView = segue.destination as! SelectSongsTableViewController
            self.selectSongsController = tableView
            self.selectSongsController.delegate = self
        } else {
            print("error")
        }
    }
    

}
