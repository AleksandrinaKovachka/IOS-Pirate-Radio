//
//  PlaylistTableViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 20.07.21.
//

import UIKit

class PlaylistTableViewController: UITableViewController {
    
    var searchController : UISearchController!
    
    var playlistNames: [String] = ["New Playlist..."]
    var playlistData: [String: [String: String]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.allowsMultipleSelectionDuringEditing = false

        self.searchController = UISearchController.init(searchResultsController: nil)
        
        self.tableView.tableHeaderView = self.searchController.searchBar
        
        searchController.searchBar.delegate = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true

        self.initPlaylistData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onHasCreatePlaylist(_:)), name: .hasCreatePlaylist, object: nil)
    }
    
    // MARK: - init playlist data
    
    func initPlaylistData() {
        
        if let playlistData = UserDefaults.standard.object(forKey: "PlaylistTitlesAndSongs") as? [String: [String: String]] {
            self.playlistData = playlistData
            
            self.playlistNames.append(contentsOf: self.playlistData.keys.sorted())
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if self.playlistNames.count == 1 && self.playlistNames == ["New Playlist..."] {
            setDefaultMessage(message: "There is no playlist")
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        
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
        
        self.searchController.dismiss(animated: true, completion: nil)
        
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
        if self.playlistNames[indexPath.row] == "New Playlist..." {
            return false
        }
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
        self.playlistData.removeAll()
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

    // MARK: - Search playlist
    
    func findPlaylist(text: String) {
        
        var searchedPlaylistNames: [String] = []
        
        for name in self.playlistNames {
            if name.uppercased().contains(text.uppercased()) {
                searchedPlaylistNames.append(name)
            }
        }
        
        self.playlistNames.removeAll()
        self.playlistNames = searchedPlaylistNames
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setDefaultMessage(message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        tableView.backgroundView = messageLabel
    }
}

extension PlaylistTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let text = searchBar.text!
        self.findPlaylist(text: text)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.playlistNames.removeAll()
        self.playlistNames = ["New Playlist..."]
        self.playlistNames.append(contentsOf: self.playlistData.keys.sorted())
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
