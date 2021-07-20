//
//  PlaylistTableViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 20.07.21.
//

import UIKit

class PlaylistTableViewController: UITableViewController {
    
    var playlistNames: [String] = ["New Playlist...", "Pop"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
                
                self.navigationController?.pushViewController(songsController, animated: true)
            }
        }
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
