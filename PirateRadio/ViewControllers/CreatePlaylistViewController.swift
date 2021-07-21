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
        
        var toastMessage: String = ""
        if self.playlistNameTextField.text == "" {
            toastMessage = "Input name"
            
        } else if self.playlistNameTextField.text == "New Playlist..." {
            toastMessage.append(", different form New Playlist...!")
        }
        
        if self.playlistSongs.count == 0 {
            toastMessage.append("\nSelect at least one song!")
        }
        
        if toastMessage == "" {
            savePlaylistData()
        } else {
            self.view.makeToast(toastMessage, duration: 2.0, position: ToastPosition.center)
        }
    }
    
    func savePlaylistData() {
        if var playlistData = UserDefaults.standard.object(forKey: "PlaylistTitlesAndSongs") as? [String: [String: String]] {
            playlistData[self.playlistNameTextField.text!] = self.playlistSongs
            UserDefaults.standard.set(playlistData, forKey: "PlaylistTitlesAndSongs")
            print("successful added")
        } else {
            UserDefaults.standard.set([self.playlistNameTextField.text: self.playlistSongs], forKey: "PlaylistTitlesAndSongs")
            print("successful")
        }

        NotificationCenter.default.post(name: .hasCreatePlaylist, object: nil, userInfo: [self.playlistNameTextField.text: self.playlistSongs])
        
        self.navigationController!.popViewController(animated: true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is SelectSongsTableViewController {
            let tableView = segue.destination as! SelectSongsTableViewController
            self.selectSongsController = tableView
            self.selectSongsController.delegate = self
        }
        
    }

}
