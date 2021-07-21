//
//  PlaylistTableViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 20.07.21.
//

import UIKit

class PlaylistTableViewController: UITableViewController {
    
    var playlistNames: [String] = ["New Playlist..."]
    var playlistData: [String: [String: String]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initPlaylistData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onHasCreatePlaylist(_:)), name: .hasCreatePlaylist, object: nil)
    }
    
    // MARK: - init playlist data
    
    func initPlaylistData() {
        
        if let playlistData = UserDefaults.standard.object(forKey: "PlaylistTitlesAndSongs") as? [String: [String: String]] {
            self.playlistData = playlistData
            
            let names = self.playlistData.keys
            
            self.playlistNames.append(contentsOf: names.sorted())
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.playlistNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath) as! PlaylistTableViewCell

        cell.playlistNameLabel.text = self.playlistNames[indexPath.row]
        
        if self.playlistNames[indexPath.row] == "New Playlist..." {
            cell.playlistImageView.image = UIImage(named: "new_playlist")
        } else {
            cell.playlistImageView.image = UIImage(systemName: "music.note.list")
            cell.playlistImageView.tintColor = UIColor(red: randomColor(), green: randomColor(), blue: randomColor(), alpha: 1.0)
        }

        return cell
    }
    
    private func randomColor() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.playlistNames[indexPath.row] == "New Playlist..." {
            if let createPlaylistController = self.storyboard?.instantiateViewController(identifier: "CreatePlaylistViewController") as? CreatePlaylistViewController {
                
                self.navigationController?.pushViewController(createPlaylistController, animated: true)
            }
        } else {
            if let songsController = self.storyboard?.instantiateViewController(identifier: "SongsViewController") as? SongsViewController {
                
                songsController.musicData = self.playlistData[self.playlistNames[indexPath.row]]!
                
                self.navigationController?.pushViewController(songsController, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            deletePlaylist(playlistName: self.playlistNames[indexPath.row], index: indexPath.row)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Notification for create new Playlist
    
    @objc func onHasCreatePlaylist(_ notification: Notification) {
        self.playlistData = [:]
        self.playlistNames = ["New Playlist..."]
        initPlaylistData()
            
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Delete Playlist

    func deletePlaylist(playlistName: String, index: Int) {
        if var playlistData = UserDefaults.standard.object(forKey: "PlaylistTitlesAndSongs") as? [String: [String: String]] {
            playlistData.removeValue(forKey: playlistName)
            UserDefaults.standard.set(playlistData, forKey: "PlaylistTitlesAndSongs")
        }
        
        self.playlistData.removeValue(forKey: playlistName)
        self.playlistNames.remove(at: index)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
